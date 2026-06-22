output "vcn" {
  value       = oci_core_vcn.this
  description = "The VCN object"
}

output "route_table_public_id" {
  value       = oci_core_route_table.this_public.id
  description = "OCID of the public (internet-gateway) route table — attach LB/public subnets here"
}

output "route_table_private_id" {
  value       = oci_core_route_table.this_private.id
  description = "OCID of the private (NAT + service gateway) route table — attach worker/node/pod/bastion subnets here"
}

output "service_gateway_cidr" {
  value       = local.oci_all_service_gateway[0].cidr_block
  description = "The 'all <REGION> services' CIDR label of the service gateway, used as the SERVICE_CIDR_BLOCK destination in security-list egress rules"
}
