# Get all container image options for cluster

resource "oci_containerengine_node_pool" "this" {
  cluster_id         = var.cluster_ocid
  compartment_id     = var.compartment_id
  name               = "${var.name}-node-pool"
  node_shape         = var.node_shape
  kubernetes_version = "v${var.kubernetes_version}"

  dynamic "initial_node_labels" {
    for_each = var.node_labels
    content {
      key   = initial_node_labels.key
      value = initial_node_labels.value
    }
  }

  freeform_tags = var.freeform_tags
  node_config_details {
    kms_key_id = var.kms_key_id
    placement_configs {
      availability_domain = var.availability_domain
      subnet_id           = var.worker_pool_subnet_id
    }
    size          = var.node_pool_size
    freeform_tags = var.instance_tags
    node_pool_pod_network_option_details {
      cni_type       = "OCI_VCN_IP_NATIVE"
      pod_subnet_ids = [var.worker_pool_subnet_id]
    }
  }
  node_shape_config {
    memory_in_gbs = var.memory_in_gbs
    ocpus         = var.num_ocpus
  }
  node_source_details {
    image_id    = var.image_id
    source_type = "image"

    boot_volume_size_in_gbs = 50
  }
  ssh_public_key = var.ssh_public_key
}