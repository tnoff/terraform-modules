# Cloud-init script that runs OKE initialization then mitigates OSMS OOM risk:
#   - Creates a swap file so dnf memory spikes have overflow room
#   - Disables oracle-cloud-agent-updater (the OSMS mechanism on this image; osms-agent.service does not exist)
#   - Kills any running dnf processes
# IMPORTANT: Must include the default OKE init script or nodes won't join the cluster
locals {
  limit_osms_cloud_init = var.limit_osms_memory ? base64encode(<<-EOF
#!/bin/bash
# First, run the default OKE initialization script (required for node to join cluster)
curl --fail -H "Authorization: Bearer Oracle" -L0 http://169.254.169.254/opc/v2/instance/metadata/oke_init_script | base64 --decode >/var/run/oke-init.sh
bash /var/run/oke-init.sh

# Create swap file to provide overflow buffer for dnf memory spikes
fallocate -l ${var.osms_swap_size_gb}G /swapfile
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
echo '/swapfile none swap sw 0 0' >> /etc/fstab

# Disable the OCI agent updater and kill any running dnf to prevent OOM
# oracle-cloud-agent-updater manages OSMS on this image (osms-agent.service does not exist)
systemctl disable --now oracle-cloud-agent-updater || true
pkill -9 dnf || true
EOF
  ) : null

  node_metadata = var.limit_osms_memory ? merge(
    var.node_metadata,
    { user_data = local.limit_osms_cloud_init }
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