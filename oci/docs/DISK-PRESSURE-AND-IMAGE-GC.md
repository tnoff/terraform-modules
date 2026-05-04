# Node Disk Pressure on OKE: Boot-Volume Sizing and Image GC

## The Problem

Pods on OKE worker nodes can be evicted with errors like:

```
The node was low on resource: ephemeral-storage.
Threshold quantity: 5701946799, available: 4580476Ki.
Container build was using 1412256Ki, request is 0,
has larger consumption of ephemeral-storage.
```

This typically surfaces in CI jobs (GitLab Runner, Tekton, etc.) but can hit any pod that pulls a fresh container image when the node is already close to the eviction threshold. Downstream symptoms include `ImagePullBackOff` and Docker Hub rate-limit errors as the cluster repeatedly retries failed pulls.

## Root Cause

Two layered issues on default OKE Oracle Linux node pools:

### 1. Boot volume vs root partition mismatch

OCI Oracle Linux platform images carve the boot volume into multiple partitions (EFI, `/boot`, `/boot/efi`, swap, root). On a **50 GB** boot volume, the root filesystem ends up at roughly **35 GiB** — the rest of the volume is unallocated free space at the end of the disk.

You can see this with `lsblk` on a node: the `oraclevdb` device is 50 GB but `ocivolume-root` LV is ~35 GiB.

### 2. Lenient default image-GC

Kubelet's default image garbage-collection thresholds are:

| Setting | Default | Behavior |
|---|---|---|
| `image-gc-high-threshold` | 85% | GC starts when imagefs fills past this |
| `image-gc-low-threshold` | 80% | GC stops when fs is cleaned down to this |
| eviction-hard `nodefs.available` | 10–15% | Pods evicted below this |

On a 35 GiB root filesystem, 85% = 30 GiB. That leaves only ~5 GiB headroom before the eviction threshold trips. CI nodes routinely cache 20+ GiB of images at steady state, and a single concurrent image pull can punch through eviction faster than image-GC can clean up.

## What This Cluster Hit

Discovered when investigating ephemeral-storage evictions on the `oke-kms` node pool:

- Each node: **38 GB capacity / 32 GiB allocatable** (50 GB boot volume, only ~35 GiB on root partition)
- Steady-state usage: **21–25 GB used** per node, almost entirely from `/var/lib/containers/storage/overlay`
- 32 distinct images / 273 overlay layers cached, totaling ~22 GB uncompressed on disk
- A new image pull during a CI job tipped a node from ~24 GB used to past the eviction threshold; image-GC didn't kick in until 85% (30 GB) and the eviction threshold won the race

The image cache itself was entirely legitimate (postgres/spilo, mimir, tempo, build base images, OKE system images, etc.) — the cluster was just sized too tight.

## The Solution

Both fixes are wired into the `enable_node_init_customizations` cloud-init script (see also [OSMS-AND-MEMORY.md](OSMS-AND-MEMORY.md) for the OSMS memory cap that lives in the same script).

### 1. `oci-growfs` to reclaim the full boot volume

Runs **before** kubelet starts, so kubelet registers with the correct allocatable ephemeral-storage:

```bash
/usr/libexec/oci-growfs -y || true
```

This is OCI's documented utility for extending the root partition on Oracle Linux instances. It only acts on XFS/ext4, is idempotent (no-op if already grown), and works on a mounted filesystem.

Effect: ~35 GiB → ~48 GiB on a 50 GB volume.

### 2. Aggressive kubelet image-GC

Passed via `--kubelet-extra-args` to the OKE init script:

```bash
bash /var/run/oke-init.sh --kubelet-extra-args \
  "--image-gc-high-threshold=60 --image-gc-low-threshold=40"
```

Defaults are 60/40 (vs kubelet's stock 85/80). Cleanup triggers far earlier and reclaims more aggressively, keeping the disk well clear of the eviction threshold even on image-heavy nodes.

Variables: `image_gc_high_threshold_percent`, `image_gc_low_threshold_percent` — tune as needed; module validates that high > low.

## Manual Remediation for Existing Nodes

`oci-growfs` and kubelet config changes only run via cloud-init on first boot. To fix nodes that pre-date the module change without rolling the pool:

```bash
# 1. Reclaim the full boot volume (safe + idempotent on a running node)
sudo /usr/libexec/oci-growfs -y

# 2. Restart kubelet so it re-registers with the new ephemeral-storage capacity
sudo systemctl restart kubelet
```

Image-GC threshold changes **cannot** be applied to a running kubelet without restarting it with new flags — for that you need to roll the nodes (drain + replace) after the module ref is bumped. In practice, growfs alone often gives enough headroom that you can defer the roll.

## Why Not Just Use a Bigger Boot Volume?

You can — increasing `boot_volume_size_in_gbs` in the node pool resource works and is the simplest fix. But:

- It only addresses the partition-size symptom, not the lenient image-GC default. A node with 100 GB will still let the cache grow to 85 GB before doing anything.
- It costs more (Block Storage is billed per GB-month).
- It still requires a node-pool roll.

The cloud-init approach fixes both root causes without changing the volume size, and the GC tuning is cheap insurance for any future image-heavy workload.

## Diagnosing Disk Pressure on a Node

Quick check of node-level filesystem usage via the kubelet stats summary endpoint:

```bash
kubectl get --raw "/api/v1/nodes/<node-ip>/proxy/stats/summary" \
  | jq '.node.fs, .node.runtime.imageFs'
```

Per-pod ephemeral usage on a node:

```bash
kubectl get --raw "/api/v1/nodes/<node-ip>/proxy/stats/summary" \
  | jq '.pods | map({pod: .podRef.name, ns: .podRef.namespace,
                      ephemeral: ."ephemeral-storage".usedBytes})
        | sort_by(.ephemeral) | reverse | .[0:10]'
```

For a deeper look (image cache, log dirs), spawn a privileged debug pod with a hostPath mount:

```bash
kubectl debug node/<node-name> --image=alpine:3 --profile=sysadmin -- \
  sh -c 'du -sh /host/var/lib/containers/* /host/var/log/* 2>/dev/null | sort -h | tail -20'
```

(On OKE / Oracle Linux the container runtime is **CRI-O**, not containerd — the image cache lives at `/var/lib/containers/storage/overlay`, not `/var/lib/containerd`.)

## References

- [oci-growfs Command Reference (Oracle)](https://docs.oracle.com/en-us/iaas/Content/Compute/References/oci-growfs.htm)
- [OKE: Extending the Root Partition of Worker Nodes](https://docs.oracle.com/en-us/iaas/Content/ContEng/Tasks/contengextendingrootpartitionmanually.htm)
- [OKE: Using Custom Cloud-init Initialization Scripts](https://docs.oracle.com/en-us/iaas/Content/ContEng/Tasks/contengusingcustomcloudinitscripts.htm)
- [Kubelet garbage collection (kubernetes.io)](https://kubernetes.io/docs/concepts/architecture/garbage-collection/#containers-images)
- [Node-pressure eviction (kubernetes.io)](https://kubernetes.io/docs/concepts/scheduling-eviction/node-pressure-eviction/)
- [KEP-4210: Image GC max age (k8s 1.30 beta, 1.35 GA — config-file only)](https://github.com/kubernetes/enhancements/tree/master/keps/sig-node/4210-max-image-gc-age)
