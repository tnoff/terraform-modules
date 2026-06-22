# OKE networking — composition recipe

OKE networking is built from three independent, single-purpose modules. There is
no wrapper/facade module: the live config (`terraform/`) composes them directly so
that all state moves (`moved` blocks) live with the state, not in this repo.

| Module | Creates |
|---|---|
| [`oci/oke-vcn`](../oke-vcn) | VCN + service/NAT/internet gateways + public & private route tables |
| [`oci/oke-security-lists`](../oke-security-lists) | Every security list, from per-role subnet CIDR **lists** (`api_cidrs`, `node_cidrs`, `pod_cidrs`, `lb_cidrs`, `bastion_cidrs`) |
| [`oci/oke-subnet`](../oke-subnet) | One subnet (+ optional route-table attachment). Instantiate once per subnet, passing the SL id(s) from `oke-security-lists` |

Wire order is data-clean: the security lists need only CIDRs (not subnet OCIDs),
and subnets need the SL OCIDs at create time, so **vcn → security-lists → subnets**.

## Example

```hcl
module "oke_vcn" {
  source           = "git::https://gitlab.com/tnoff-projects/terraform-modules.git//oci/oke-vcn?ref=<sha>"
  compartment_ocid = var.compartment_ocid
  display_name     = "oke"
  vcn_cidr_block   = "10.0.0.0/16"
}

module "oke_security_lists" {
  source               = "git::https://gitlab.com/tnoff-projects/terraform-modules.git//oci/oke-security-lists?ref=<sha>"
  compartment_ocid     = var.compartment_ocid
  vcn_ocid             = module.oke_vcn.vcn.id
  display_name         = "oke"
  service_gateway_cidr = module.oke_vcn.service_gateway_cidr

  api_cidrs     = ["10.0.0.0/28"]
  node_cidrs    = ["10.0.11.0/24"] # worker-node VNIC subnet(s); append to scale out
  pod_cidrs     = ["10.0.64.0/18"] # VCN-native pod subnet(s)
  lb_cidrs      = ["10.0.20.0/24"]
  bastion_cidrs = ["10.0.30.0/24"]
}

# Kubernetes API / control-plane subnet — no route-table attachment, so it inherits
# the VCN default route table (omit route_table_ocid / leave it null).
module "oke_subnet_api" {
  source            = "git::https://gitlab.com/tnoff-projects/terraform-modules.git//oci/oke-subnet?ref=<sha>"
  compartment_ocid  = var.compartment_ocid
  vcn_ocid          = module.oke_vcn.vcn.id
  display_name      = "oke-k8s-api-subnet"
  dns_label         = "k8s"
  cidr_block        = "10.0.0.0/28"
  security_list_ids = [module.oke_security_lists.security_list_ids.api]
}

# Worker-node VNIC subnet — private route table.
module "oke_subnet_node" {
  source            = "git::https://gitlab.com/tnoff-projects/terraform-modules.git//oci/oke-subnet?ref=<sha>"
  compartment_ocid  = var.compartment_ocid
  vcn_ocid          = module.oke_vcn.vcn.id
  display_name      = "oke-node"
  dns_label         = "node"
  cidr_block        = "10.0.11.0/24"
  security_list_ids = [module.oke_security_lists.security_list_ids.node]
  route_table_ocid  = module.oke_vcn.route_table_private_id
}

# VCN-native pod subnet — private route table.
module "oke_subnet_pods" {
  source            = "git::https://gitlab.com/tnoff-projects/terraform-modules.git//oci/oke-subnet?ref=<sha>"
  compartment_ocid  = var.compartment_ocid
  vcn_ocid          = module.oke_vcn.vcn.id
  display_name      = "oke-pods"
  dns_label         = "pods"
  cidr_block        = "10.0.64.0/18"
  security_list_ids = [module.oke_security_lists.security_list_ids.pods]
  route_table_ocid  = module.oke_vcn.route_table_private_id
}

# Load-balancer subnet — public route table, public IPs allowed.
module "oke_subnet_lb" {
  source                     = "git::https://gitlab.com/tnoff-projects/terraform-modules.git//oci/oke-subnet?ref=<sha>"
  compartment_ocid           = var.compartment_ocid
  vcn_ocid                   = module.oke_vcn.vcn.id
  display_name               = "oke-lb"
  dns_label                  = "lb"
  cidr_block                 = "10.0.20.0/24"
  security_list_ids          = [module.oke_security_lists.security_list_ids.lb]
  route_table_ocid           = module.oke_vcn.route_table_public_id
  prohibit_internet_ingress  = false
  prohibit_public_ip_on_vnic = false
}

# Bastion subnet — private route table.
module "oke_subnet_bastion" {
  source            = "git::https://gitlab.com/tnoff-projects/terraform-modules.git//oci/oke-subnet?ref=<sha>"
  compartment_ocid  = var.compartment_ocid
  vcn_ocid          = module.oke_vcn.vcn.id
  display_name      = "oke-bastion"
  dns_label         = "bastion"
  cidr_block        = "10.0.30.0/24"
  security_list_ids = [module.oke_security_lists.security_list_ids.bastion]
  route_table_ocid  = module.oke_vcn.route_table_private_id
}
```

Then feed the outputs to the cluster / node-pool / bastion modules, e.g.
`module.oke_vcn.vcn.id`, `module.oke_subnet_api.subnet.id`,
`module.oke_subnet_lb.subnet.id`, `module.oke_subnet_node.subnet.id`,
`module.oke_subnet_pods.subnet.id`, `module.oke_subnet_bastion.subnet.id`.

## Security-list lifecycle

`oke-security-lists` keeps the per-role lifecycle OKE expects:

- `api`, `bastion` — fully terraform-managed (the `api` list carries the VCN-native
  `6443`/`12250`/ICMP rules from the node + pod CIDRs; without them new nodes never
  go Ready).
- `node`, `pods` — `ignore_changes = [ingress_security_rules]` (OKE injects runtime
  rules).
- `lb` — `ignore_changes` on both directions (OKE manages it per Service).
