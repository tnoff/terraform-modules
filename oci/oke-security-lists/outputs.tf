output "security_list_ids" {
  value = {
    api     = oci_core_security_list.managed["api"].id
    bastion = oci_core_security_list.managed["bastion"].id
    node    = oci_core_security_list.oke_managed_ingress["node"].id
    pods    = oci_core_security_list.oke_managed_ingress["pods"].id
    lb      = oci_core_security_list.lb.id
  }
  description = "Map of role => security-list OCID, for wiring into each subnet's security_list_ids"
}
