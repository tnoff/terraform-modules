# VCN + gateways + route tables for an OKE cluster.
#
# This is the "base" of the OKE networking stack: it owns the VCN, the three
# gateways (service / NAT / internet) and the public + private route tables.
# Subnets and security lists live in the sibling oke-subnet / oke-security-lists
# modules and consume this module's outputs (VCN id, route table ids, the
# service-gateway CIDR label).

data "oci_core_services" "this" {}

locals {
  oci_all_service_gateway = [for service in data.oci_core_services.this.services : service if length(regexall("All [A-Z]+ Services", service.name)) > 0]
}

resource "oci_core_vcn" "this" {
  compartment_id = var.compartment_ocid
  cidr_block     = var.vcn_cidr_block
  display_name   = "${var.display_name}-network"
  # Doesn't seem to like dashes in name
  dns_label     = replace(var.display_name, "-", "")
  freeform_tags = var.freeform_tags
  defined_tags  = var.defined_tags

  lifecycle {
    ignore_changes = [
      # Remove this
      dns_label,
    ]
  }
}

resource "oci_core_service_gateway" "this" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.this.id
  display_name   = "${var.display_name}-all-oci-services"
  freeform_tags  = var.freeform_tags
  defined_tags   = var.defined_tags
  services {
    service_id = local.oci_all_service_gateway[0].id
  }
}

resource "oci_core_nat_gateway" "this" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.this.id
  display_name   = "${var.display_name}-nat-gateway"
  freeform_tags  = var.freeform_tags
  defined_tags   = var.defined_tags
}

resource "oci_core_internet_gateway" "this" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.this.id
  enabled        = true
  freeform_tags  = var.freeform_tags
  defined_tags   = var.defined_tags
}

resource "oci_core_route_table" "this_public" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.this.id

  display_name  = "${var.display_name}-public"
  freeform_tags = var.freeform_tags
  defined_tags  = var.defined_tags

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.this.id
  }
}

resource "oci_core_route_table" "this_private" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.this.id

  display_name  = "${var.display_name}-private"
  freeform_tags = var.freeform_tags
  defined_tags  = var.defined_tags

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_nat_gateway.this.id
  }
  route_rules {
    destination       = local.oci_all_service_gateway[0].cidr_block
    destination_type  = "SERVICE_CIDR_BLOCK"
    network_entity_id = oci_core_service_gateway.this.id
  }
}
