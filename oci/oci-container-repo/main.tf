resource "oci_artifacts_container_repository" "this" {
  compartment_id = var.compartment_id
  display_name   = var.name
  freeform_tags  = var.freeform_tags

  is_immutable = var.is_immutable
  is_public    = var.is_public
  readme {
    content = var.readme_text
    format  = "text/plain"
  }
}