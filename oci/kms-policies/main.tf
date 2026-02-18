data "oci_identity_region_subscriptions" "this" {
  tenancy_id = var.oci_tenancy_ocid
}


# Policy to allow Object Storage service to use KMS keys across all regions
# Supports buckets in both apps and backup compartments
resource "oci_identity_policy" "kms_object_storage_policy" {
  compartment_id = var.oci_tenancy_ocid
  name           = "kms-object-storage-policy"
  description    = "Allow Object Storage to use KMS keys for encryption"

  statements = flatten(flatten([
    for region in data.oci_identity_region_subscriptions.this.region_subscriptions : flatten([
      for compartment in var.target_compartment_names : [
        "Allow service objectstorage-${region.region_name} to use keys in compartment ${var.kms_key_compartment_name} where all {target.compartment.name = '${compartment}', target.key.id = '${var.kms_key_ocid}'}",

      ]
  ])]))
}

resource "oci_identity_policy" "kms_oke_policies" {
  compartment_id = var.oci_tenancy_ocid
  name           = "kms-oke-policy"
  description    = "Allow OKE and other compute resources to use KMS keys for encryption"

  statements = [
    # Block storage for PersistentVolumes
    "Allow service blockstorage to use keys in compartment ${var.kms_key_compartment_name} where target.key.id = '${var.kms_key_ocid}'",
    "Allow service blockstorage to use key-delegates in compartment ${var.kms_key_compartment_name} where target.key.id = '${var.kms_key_ocid}'",

    # OKE service for etcd encryption (Kubernetes secrets at rest)
    "Allow service oke to use keys in compartment ${var.kms_key_compartment_name} where target.key.id = '${var.kms_key_ocid}'",
    "Allow service oke to use key-delegates in compartment ${var.kms_key_compartment_name} where target.key.id = '${var.kms_key_ocid}'",

    # Compute service for boot volumes
    "Allow service compute to use keys in compartment ${var.kms_key_compartment_name} where target.key.id = '${var.kms_key_ocid}'",
    "Allow service compute to use key-delegates in compartment ${var.kms_key_compartment_name} where target.key.id = '${var.kms_key_ocid}'",
  ]
}

# Policy to allow OKE cluster resource principals to use KMS keys
# Uses any-user with request.principal.type condition as per Oracle documentation
# https://docs.oracle.com/en-us/iaas/Content/ContEng/Tasks/contengencryptingdata.htm
resource "oci_identity_policy" "kms_oke_cluster_resource_principal" {
  count          = length(var.oke_cluster_compartment_ids) > 0 ? 1 : 0
  compartment_id = var.oci_tenancy_ocid
  name           = "kms-oke-cluster-resource-principal-policy"
  description    = "Allow OKE cluster resource principals to use KMS keys for encryption"

  statements = concat([
    for compartment_id in var.oke_cluster_compartment_ids :
    "Allow any-user to use keys in compartment ${var.kms_key_compartment_name} where ALL {request.principal.type = 'cluster', request.principal.compartment.id = '${compartment_id}', target.key.id = '${var.kms_key_ocid}'}"
  ])
}