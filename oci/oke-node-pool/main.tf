# Cloud-init script for OKE worker nodes. Runs in this order:
#   1. oci-growfs    — extends the root partition to the full boot volume
#                       (defaults give ~35 GiB on a 50 GB volume; growfs reclaims the rest).
#                       Runs BEFORE kubelet starts so allocatable ephemeral-storage is correct.
#   2. oke-init      — the standard OKE bootstrap, with extra kubelet flags appended:
#                       aggressive image-GC thresholds prevent the small node disk
#                       from filling up with cached images.
#   3. OSMS limits   — caps oracle-cloud-agent-updater memory so dnf is OOM-killed
#                       before Kubernetes pods are; kills any in-flight dnf.
# IMPORTANT: Must include the default OKE init script or nodes won't join the cluster.
# NOTE: osms-agent.service does not exist on current OKE images; OSMS is managed by oracle-cloud-agent-updater.
# NOTE: Do NOT create a swap file — kubelet refuses to start when swap is enabled.
locals {
  node_init_cloud_init = var.enable_node_init_customizations ? base64encode(<<-EOF
#!/bin/bash
# 1. Reclaim the full boot volume before kubelet starts.
/usr/libexec/oci-growfs -y || true

# 2. Run the default OKE init with custom kubelet flags appended.
curl --fail -H "Authorization: Bearer Oracle" -L0 http://169.254.169.254/opc/v2/instance/metadata/oke_init_script | base64 --decode >/var/run/oke-init.sh
bash /var/run/oke-init.sh --kubelet-extra-args "--image-gc-high-threshold=${var.image_gc_high_threshold_percent} --image-gc-low-threshold=${var.image_gc_low_threshold_percent}"

# 3. Cap oracle-cloud-agent-updater memory so dnf is OOM-killed before Kubernetes pods are.
mkdir -p /etc/systemd/system/oracle-cloud-agent-updater.service.d
cat > /etc/systemd/system/oracle-cloud-agent-updater.service.d/memory-limit.conf <<UNIT
[Service]
MemoryMax=${var.osms_memory_limit_mb}M
UNIT
systemctl daemon-reload
systemctl restart oracle-cloud-agent-updater || true

# Kill any dnf already running at this point
pkill -9 dnf || true
EOF
  ) : null

  node_metadata = var.enable_node_init_customizations ? merge(
    var.node_metadata,
    { user_data = local.node_init_cloud_init }
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