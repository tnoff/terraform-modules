# OSMS and Memory Issues on OKE Nodes

## The Problem

OKE worker nodes can experience Out-of-Memory (OOM) kills when the Oracle OS Management Service (OSMS) agent runs `dnf` package updates. The `dnf` process can consume 3-4GB of RAM while parsing repository metadata, which can exhaust available memory on smaller node shapes.

### Symptoms

- Pods randomly killed by OOM killer
- `node-MainThread`, `gunicorn`, or other workload processes terminated
- Console logs showing `systemd invoked oom-killer` with `dnf` consuming majority of RAM
- Memory Allocation Stalls visible in OCI monitoring metrics

### Root Cause

This is a known issue with `libdnf` metadata parsing ([Bug 1907030](https://bugzilla.redhat.com/show_bug.cgi?id=1907030)):

- `dnf` loads repository metadata into memory during updates
- OKE nodes have multiple large repos enabled (oke-packages, ksplice, Oracle Linux base)
- OKE images are swapless by default, providing no overflow buffer
- OSMS triggers full `dnf` operations automatically

The OOM killer targets Kubernetes pods (which run as BestEffort QoS without resource limits) before system processes like `dnf` because pods have higher `oom_score_adj` values.

## The Solution

This module includes a `disable_osms` variable that:

1. Runs the required OKE initialization script (installs kubelet, joins cluster)
2. Disables `osms-agent` and `oracle-cloud-agent-updater` services
3. Kills any running `dnf` processes

### Why This Is Safe for OKE

Oracle's own documentation recommends **node cycling** over in-place patching for OKE worker nodes:

> "Users should not patch, update, or otherwise modify [OKE nodes] directly for security fixes or any other purposes."

Security updates should be applied by:
1. Updating the node pool to use a newer OKE image
2. Cycling the nodes to pick up the new image

## Usage

```hcl
module "oke_node_pool" {
  source = "git::https://github.com/tnoff/terraform-modules.git//oci/oke-node-pool"

  # ... other configuration ...

  disable_osms = true  # Prevents OOM from dnf updates
}
```

## Why Cloud-Init Instead of Terraform Settings?

The OCI Console UI allows you to toggle OSMS/Oracle Cloud Agent settings on node pools, but **this setting is not exposed in the Terraform provider**.

| Resource | `agent_config` / `is_management_disabled` |
|----------|------------------------------------------|
| `oci_core_instance` | Yes |
| `oci_containerengine_node_pool` | **No** |

This is a gap in the [terraform-provider-oci](https://github.com/oracle/terraform-provider-oci/issues). Until Oracle adds support, the cloud-init approach is the only way to manage this via Infrastructure as Code.

The cloud-init method is arguably better anyway - it disables OSMS before the service even starts, whereas a Terraform setting might allow OSMS to run briefly during node initialization.

## References

- [Bug 1907030 - dnf update runs out of memory on swapless machines](https://bugzilla.redhat.com/show_bug.cgi?id=1907030)
- [OCI OOM killing dnf on compute instances](https://community.oracle.com/customerconnect/discussion/772687/oci-oom-out-of-memory-is-killing-dnf-on-newly-created-compute-instance-while-performing-dnf)
- [DNF operations use large amount of RAM - Fedora Discussion](https://discussion.fedoraproject.org/t/dnf-operations-use-large-amount-of-ram-and-may-fail-in-low-memory-environments/76389)
- [OKE Security Best Practices](https://docs.oracle.com/en-us/iaas/Content/ContEng/Tasks/contengbestpractices_topic-Security-best-practices.htm)
- [Using Custom Cloud-init Scripts for OKE](https://docs.oracle.com/en-us/iaas/Content/ContEng/Tasks/contengusingcustomcloudinitscripts.htm)
