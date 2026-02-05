resource "oci_containerengine_cluster" "this" {
  type               = "BASIC_CLUSTER"
  compartment_id     = var.compartment_ocid
  kubernetes_version = "v${var.kubernetes_version}"
  name               = "${var.display_name}-cluster"
  vcn_id             = var.vcn_ocid
  freeform_tags      = var.freeform_tags
  defined_tags       = var.defined_tags
  cluster_pod_network_options {
    cni_type = "OCI_VCN_IP_NATIVE"
  }
  options {
    persistent_volume_config {
      freeform_tags = var.freeform_tags
      defined_tags  = var.defined_tags
    }
    service_lb_subnet_ids = var.lb_subnet_ocids
  }
  kms_key_id = var.kms_key_ocid
  endpoint_config {
    is_public_ip_enabled = var.enable_public_endpoint
    nsg_ids              = []
    subnet_id            = var.api_subnet_ocid
  }
}