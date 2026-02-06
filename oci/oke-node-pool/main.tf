# Cloud-init script to disable OSMS agent
# This prevents dnf auto-updates that can consume 3-4GB RAM and trigger OOM kills
locals {
  disable_osms_cloud_init = var.disable_osms ? base64encode(<<-EOF
    #!/bin/bash
    # Disable OSMS agent to prevent memory-hungry dnf updates
    systemctl disable --now osms-agent oracle-cloud-agent-updater
    # Stop any running dnf processes
    pkill -9 dnf || true
    EOF
  ) : null

  node_metadata = var.disable_osms ? merge(
    var.node_metadata,
    { user_data = local.disable_osms_cloud_init }
  ) : var.node_metadata
}

resource "oci_containerengine_node_pool" "this" {
  cluster_id         = var.cluster_ocid
  compartment_id     = var.compartment_ocid
  name               = "${var.display_name}-node-pool"
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
  defined_tags  = var.defined_tags
  node_metadata = local.node_metadata

  node_config_details {
    kms_key_id = var.kms_key_ocid
    placement_configs {
      availability_domain = var.availability_domain
      subnet_id           = var.worker_pool_subnet_ocid
    }
    size          = var.node_pool_size
    freeform_tags = var.instance_freeform_tags
    defined_tags  = var.instance_defined_tags
    node_pool_pod_network_option_details {
      cni_type       = "OCI_VCN_IP_NATIVE"
      pod_subnet_ids = [var.worker_pool_subnet_ocid]
    }
  }
  node_shape_config {
    memory_in_gbs = var.memory_in_gbs
    ocpus         = var.num_ocpus
  }
  node_source_details {
    image_id    = var.image_ocid
    source_type = "image"

    boot_volume_size_in_gbs = 50
  }
  ssh_public_key = var.ssh_public_key
}