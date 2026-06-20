output "vcn" {
  value = oci_core_vcn.this
}

output "subnet_k8s" {
  value = oci_core_subnet.this_k8s
}

output "subnet_worker" {
  value = oci_core_subnet.this_worker
}

output "subnet_node_v2" {
  value = one(module.subnet_node_v2[*].subnet)
}

output "subnet_pods" {
  value = one(module.subnet_pods[*].subnet)
}

output "subnet_lb" {
  value = oci_core_subnet.this_lb
}

output "subnet_bastion" {
  value = oci_core_subnet.this_bastion
}