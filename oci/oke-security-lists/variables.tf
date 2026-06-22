variable "compartment_ocid" {
  type        = string
  description = "Compartment OCID for the security lists"
}

variable "vcn_ocid" {
  type        = string
  description = "OCID of the VCN the security lists belong to"
}

variable "display_name" {
  type        = string
  description = "Name prefix for the security lists (each list is named \"<display_name>-<role>\")"
}

variable "service_gateway_cidr" {
  type        = string
  description = "The 'all <REGION> services' CIDR label of the VCN service gateway (oke-vcn's service_gateway_cidr output), used as the SERVICE_CIDR_BLOCK egress destination"
}

# Per-role subnet CIDR lists. Each is a list so a future subnet of the same role
# (e.g. a second worker/node subnet or a second LB subnet) is added by appending a
# CIDR — no new resources or per-subnet peer-threading. The security-list rules
# reference these lists to build the cross-subnet allow rules.

variable "api_cidrs" {
  type        = list(string)
  default     = []
  description = "CIDRs of the Kubernetes API (control-plane endpoint) subnet(s)"
}

variable "node_cidrs" {
  type        = list(string)
  default     = []
  description = "CIDRs of the worker-node VNIC subnet(s) (a.k.a. worker_subnets)"
}

variable "pod_cidrs" {
  type        = list(string)
  default     = []
  description = "CIDRs of the VCN-native pod subnet(s)"
}

variable "lb_cidrs" {
  type        = list(string)
  default     = []
  description = "CIDRs of the load-balancer subnet(s) (lb_subnets)"
}

variable "bastion_cidrs" {
  type        = list(string)
  default     = []
  description = "CIDRs of the bastion subnet(s)"
}

variable "external_api_ingress_cidrs" {
  type        = list(string)
  default     = ["0.0.0.0/0"]
  description = "CIDRs allowed to reach the Kubernetes API server on 6443 (public kubectl access). Default 0.0.0.0/0."
}

variable "freeform_tags" {
  type        = map(any)
  default     = {}
  description = "Freeform tags for the security lists"
}

variable "defined_tags" {
  type        = map(string)
  default     = {}
  description = "Defined tags for the security lists"
}
