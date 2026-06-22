# Generic OKE subnet + (optional) route-table attachment.
#
# Subnet-only: the security list is created centrally by the oke-security-lists
# module and its OCID(s) are passed in via var.security_list_ids. The route-table
# attachment is created only when var.route_table_ocid is set (the API/control-plane
# subnet inherits the VCN default route table and passes null).

resource "oci_core_subnet" "this" {
  compartment_id    = var.compartment_ocid
  vcn_id            = var.vcn_ocid
  cidr_block        = var.cidr_block
  display_name      = var.display_name
  dns_label         = var.dns_label
  freeform_tags     = var.freeform_tags
  defined_tags      = var.defined_tags
  security_list_ids = var.security_list_ids

  prohibit_internet_ingress  = var.prohibit_internet_ingress
  prohibit_public_ip_on_vnic = var.prohibit_public_ip_on_vnic

  lifecycle {
    ignore_changes = [dns_label]
  }
}

resource "oci_core_route_table_attachment" "this" {
  count          = var.route_table_ocid == null ? 0 : 1
  subnet_id      = oci_core_subnet.this.id
  route_table_id = var.route_table_ocid
}
