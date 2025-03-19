resource "oci_identity_policy" "this" {
  compartment_id = var.tenancy_ocid
  description    = "${var.compartment_name} OKE Cluster Policies"
  name           = "oke-cluster-policies-${var.compartment_name}"
  statements = [
    "ALLOW any-user to manage volumes in compartment ${var.compartment_name} where request.principal.type = 'cluster'",
    "ALLOW any-user to manage volume-attachments in compartment ${var.compartment_name} where request.principal.type = 'cluster'",
    "Allow any-user to use keys in compartment ${var.compartment_name} where ALL {request.principal.type = 'cluster', target.key.id = '${var.kms_key_id}'}",
  ]
}