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

This module includes a `limit_osms_memory` variable that applies mitigations at node boot via cloud-init:

1. **Swap file** — adds a configurable swap file (default 2GB) so `dnf` memory spikes have an overflow buffer rather than immediately exhausting RAM.
2. **Disable `oracle-cloud-agent-updater`** — stops the OCI agent updater service, which is the mechanism that triggers OSMS `dnf` runs on current OKE images. (`osms-agent.service` does not exist on these images; OSMS is managed by `oracle-cloud-agent-updater`.)
3. **Kill running `dnf` processes** — any `dnf` already in flight when the script runs is terminated.

> **Note:** A previous approach attempted to cap `osms-agent.service` memory via systemd `MemoryMax`. This did not work because `osms-agent.service` does not exist on current OKE images — the OSMS functionality is provided by `oracle-cloud-agent-updater` instead.

## Usage

```hcl
module "oke_node_pool" {
  source = "git::https://github.com/tnoff/terraform-modules.git//oci/oke-node-pool"

  # ... other configuration ...

  limit_osms_memory = true   # enable swap + agent-updater disable mitigations
  osms_swap_size_gb = 2      # optional, default 2
}
```

## Why Not Just Disable OSMS?

This effectively does disable OSMS-driven updates by stopping `oracle-cloud-agent-updater`. On current OKE node images, `osms-agent.service` does not exist as a standalone unit — the update agent is `oracle-cloud-agent-updater`. Disabling it is the only reliable way to prevent background `dnf` activity via Infrastructure as Code, since the Terraform OCI provider does not expose agent config on node pools (see below).

## Why Cloud-Init Instead of Terraform Settings?

The OCI Console UI allows you to toggle OSMS/Oracle Cloud Agent settings on node pools, but **this setting is not exposed in the Terraform provider**.

| Resource | `agent_config` / `is_management_disabled` |
|----------|------------------------------------------|
| `oci_core_instance` | Yes |
| `oci_containerengine_node_pool` | **No** |

This is a gap in the [terraform-provider-oci](https://github.com/oracle/terraform-provider-oci/issues). Until Oracle adds support, the cloud-init approach is the only way to manage this via Infrastructure as Code.

## References

- [Bug 1907030 - dnf update runs out of memory on swapless machines](https://bugzilla.redhat.com/show_bug.cgi?id=1907030)
- [OCI OOM killing dnf on compute instances](https://community.oracle.com/customerconnect/discussion/772687/oci-oom-out-of-memory-is-killing-dnf-on-newly-created-compute-instance-while-performing-dnf)
- [DNF operations use large amount of RAM - Fedora Discussion](https://discussion.fedoraproject.org/t/dnf-operations-use-large-amount-of-ram-and-may-fail-in-low-memory-environments/76389)
- [systemd Resource Control - MemoryMax](https://www.freedesktop.org/software/systemd/man/latest/systemd.resource-control.html#MemoryMax=bytes)
- [OKE Security Best Practices](https://docs.oracle.com/en-us/iaas/Content/ContEng/Tasks/contengbestpractices_topic-Security-best-practices.htm)
- [Using Custom Cloud-init Scripts for OKE](https://docs.oracle.com/en-us/iaas/Content/ContEng/Tasks/contengusingcustomcloudinitscripts.htm)
