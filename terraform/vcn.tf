resource "oci_core_vcn" "tf-vcn" {
  cidr_block     = "10.0.0.0/16"
  compartment_id = oci_identity_compartment.tf-compartment.id
  display_name   = "sandbox-vcn"
  dns_label      = "sandboxvcn"
}

resource "oci_core_internet_gateway" "tf-ig" {
  compartment_id = oci_identity_compartment.tf-compartment.id
  display_name   = "sandbox-ig"
  vcn_id         = oci_core_vcn.tf-vcn.id
}

resource "oci_core_route_table" "tf-public-rt" {
  compartment_id = oci_identity_compartment.tf-compartment.id
  vcn_id         = oci_core_vcn.tf-vcn.id
  display_name   = "sandbox-public-rt"
}

resource "oci_core_route_table" "tf-private-rt" {
  compartment_id = oci_identity_compartment.tf-compartment.id
  vcn_id         = oci_core_vcn.tf-vcn.id
  display_name   = "sandbox-private-rt"
}

resource "oci_core_subnet" "tf-public-subnet" {
  cidr_block     = "10.0.66.0/24"
  compartment_id = oci_identity_compartment.tf-compartment.id
  display_name   = "sandbox-public-subnet"
  dns_label      = "sandboxpubsnet"
  vcn_id         = oci_core_vcn.tf-vcn.id
  route_table_id = oci_core_route_table.tf-public-rt.id
}

resource "oci_core_subnet" "tf-private-subnet" {
  cidr_block                 = "10.0.0.0/24"
  compartment_id             = oci_identity_compartment.tf-compartment.id
  display_name               = "sandbox-private-subnet"
  dns_label                  = "sandboxprisnet"
  vcn_id                     = oci_core_vcn.tf-vcn.id
  route_table_id             = oci_core_route_table.tf-private-rt.id
  prohibit_public_ip_on_vnic = true
}

resource "oci_core_security_list" "tf-public-sl" {
  compartment_id = oci_identity_compartment.tf-compartment.id
  display_name   = "sandbox-public-sl"
  vcn_id         = oci_core_vcn.tf-vcn.id
  egress_security_rules {
    destination = "0.0.0.0/0"
    protocol    = "all"
  }

  ingress_security_rules {
    source   = var.home_public_ip
    protocol = "all"
  }
}

resource "oci_core_security_list" "tf-private-sl" {
  compartment_id = oci_identity_compartment.tf-compartment.id
  display_name   = "sandbox-private-sl"
  vcn_id         = oci_core_vcn.tf-vcn.id
  egress_security_rules {
    destination = "0.0.0.0/0"
    protocol    = "all"
  }
}
