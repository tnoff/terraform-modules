# Exactly one of this/this_autoscaled exists (see main.tf); coalesce resolves to
# whichever is active so consumers keep referencing a single `node_pool` object.
output "node_pool" {
  value = coalesce(
    one(oci_containerengine_node_pool.this[*]),
    one(oci_containerengine_node_pool.this_autoscaled[*]),
  )
}

# The image the pool is using: image_ocid if pinned, otherwise the one looked up.
output "image_ocid" {
  value = local.image_ocid
}
