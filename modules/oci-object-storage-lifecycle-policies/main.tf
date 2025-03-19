data "oci_identity_region_subscriptions" "this" {
  tenancy_id = var.tenancy_ocid
}

locals {
  statements = flatten([
    for compartment in var.compartment_ocids : [
      for region in data.oci_identity_region_subscriptions.this.region_subscriptions : [
        "Allow service objectstorage-${region.region_name} to manage object-family in compartment ${compartment}"
      ]
    ]
  ])
}

resource "oci_identity_policy" "this" {
  compartment_id = var.tenancy_ocid
  description    = "object storage lifecycle admin policies"
  name           = "object-storage-lifecycle"
  statements     = local.statements
}