# OKE node-pool init customizations

`oci/oke-node-pool` has an opt-in `enable_node_init_customizations` variable.
When set, the node pool boots with a custom cloud-init `user_data` script that
re-runs the default OKE init first (so nodes still join the cluster) and then
applies three mitigations for small-boot-volume Oracle Linux workers. The
script lives in the module; the variable descriptions in
[`terraform.md`](https://github.com/tnoff/terraform-modules/blob/main/oci/oke-node-pool/terraform.md) are authoritative for defaults
and validation.

```hcl
module "oke_node_pool" {
  source = "git::https://github.com/tnoff/terraform-modules.git//oci/oke-node-pool?ref=<sha>"

  # ... other configuration ...

  enable_node_init_customizations = true
  osms_memory_limit_mb            = 512  # default 512, allowed 256-4096
  image_gc_high_threshold_percent = 60   # default 60, must exceed the low threshold
  image_gc_low_threshold_percent  = 40   # default 40
}
```

## 1. `oci-growfs`: reclaim the full boot volume

OCI Oracle Linux images split the boot volume into several partitions, so the
root filesystem is smaller than the volume (about 35 GiB on a 50 GB volume; the
rest is unallocated). The script runs `/usr/libexec/oci-growfs -y` before
kubelet starts, so kubelet registers with the correct allocatable
ephemeral-storage (about 48 GiB on 50 GB). It is idempotent.

## 2. Aggressive kubelet image GC

Kubelet's stock thresholds (GC starts at 85% and stops at 80%) leave only a few
GiB of headroom on a small root filesystem, and a single image pull can reach
the eviction threshold before GC runs. The script passes
`--image-gc-high-threshold` / `--image-gc-low-threshold` (default 60/40) via
`--kubelet-extra-args`. The symptom this prevents is pod eviction with
`The node was low on resource: ephemeral-storage`, followed by
`ImagePullBackOff`.

## 3. OSMS memory cap

The Oracle OS Management Service agent runs `dnf` updates, and `dnf` can use
3-4 GB of RAM parsing repository metadata (libdnf bug 1907030). The OOM killer
then tends to pick pods rather than `dnf`. The script sets `MemoryMax` on
`oracle-cloud-agent-updater.service` (default 512 MB) so `dnf` is killed
instead, while OS patching stays enabled. On current OKE images there is no
standalone `osms-agent.service`; OSMS is managed by that updater unit.

The cap is applied in cloud-init because the OCI Terraform provider does not
expose agent configuration on `oci_containerengine_node_pool` (it does on
`oci_core_instance`).

## Applying to existing nodes

Cloud-init runs only on first boot. After bumping the module ref:

- Growfs can be applied in place: `sudo /usr/libexec/oci-growfs -y`, then
  `sudo systemctl restart kubelet`.
- Image-GC thresholds and the OSMS cap need a node roll (drain and replace).

A larger `boot_volume_size_in_gbs` also works, but it costs more, still needs a
roll, and does not fix the lenient GC defaults.

## Diagnosing disk pressure

```bash
kubectl get --raw "/api/v1/nodes/<node-ip>/proxy/stats/summary" \
  | jq '.node.fs, .node.runtime.imageFs'
```

The runtime on OKE Oracle Linux is CRI-O, so the image cache is under
`/var/lib/containers/storage/overlay`, not `/var/lib/containerd`.

## References

- [oci-growfs reference](https://docs.oracle.com/en-us/iaas/Content/Compute/References/oci-growfs.htm)
- [OKE: custom cloud-init scripts](https://docs.oracle.com/en-us/iaas/Content/ContEng/Tasks/contengusingcustomcloudinitscripts.htm)
- [Kubelet image garbage collection](https://kubernetes.io/docs/concepts/architecture/garbage-collection/#containers-images)
- [Node-pressure eviction](https://kubernetes.io/docs/concepts/scheduling-eviction/node-pressure-eviction/)
- [libdnf bug 1907030](https://bugzilla.redhat.com/show_bug.cgi?id=1907030)
