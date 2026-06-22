output "vcn" {
  value = module.vcn.vcn
}

output "subnet_k8s" {
  value = module.subnet_api.subnet
}

output "subnet_node_v2" {
  value = module.subnet_node_v2.subnet
}

output "subnet_pods" {
  value = module.subnet_pods.subnet
}

output "subnet_lb" {
  value = module.subnet_lb.subnet
}

output "subnet_bastion" {
  value = module.subnet_bastion.subnet
}

output "security_list_ids" {
  value = module.security_lists.security_list_ids
}
