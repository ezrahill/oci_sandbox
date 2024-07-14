resource "oci_core_vcn" "tf-vcn" {
  cidr_block     = "10.0.0.0/16"
  compartment_id = oci_identity_compartment.tf-compartment.id
  display_name   = "sandbox-vcn"
  #   dns_label      = "sandboxvcn"

}

resource "oci_core_internet_gateway" "tf-ig" {
  compartment_id = oci_identity_compartment.tf-compartment.id
  display_name   = "sandbox-ig"
  vcn_id         = oci_core_vcn.tf-vcn.id
}

resource "oci_core_nat_gateway" "tf-ng" {
  compartment_id = oci_identity_compartment.tf-compartment.id
  display_name   = "sandbox-ng"
  vcn_id         = oci_core_vcn.tf-vcn.id
}

data "oci_core_services" "services" {
}

resource "oci_core_service_gateway" "tf-sg" {
  compartment_id = oci_identity_compartment.tf-compartment.id
  display_name   = "sandbox-sg"
  vcn_id         = oci_core_vcn.tf-vcn.id
  services {
    service_id = data.oci_core_services.services.services[0].id
  }
}

resource "oci_core_route_table" "tf-public-rt" {
  compartment_id = oci_identity_compartment.tf-compartment.id
  vcn_id         = oci_core_vcn.tf-vcn.id
  display_name   = "sandbox-public-rt"
  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.tf-ig.id
    route_type        = "STATIC"
  }
}

resource "oci_core_route_table" "tf-private-rt" {
  compartment_id = oci_identity_compartment.tf-compartment.id
  vcn_id         = oci_core_vcn.tf-vcn.id
  display_name   = "sandbox-private-rt"
  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_nat_gateway.tf-ng.id
    route_type        = "STATIC"
  }
  route_rules {
    destination       = "all-lhr-services-in-oracle-services-network"
    destination_type  = "SERVICE_CIDR_BLOCK"
    network_entity_id = oci_core_service_gateway.tf-sg.id
    route_type        = "STATIC"
  }
}

resource "oci_core_subnet" "tf-public-subnet" {
  cidr_block     = "10.0.66.0/24"
  compartment_id = oci_identity_compartment.tf-compartment.id
  display_name   = "sandbox-public-subnet"
  #   dns_label      = "sandboxpubsnet"
  vcn_id         = oci_core_vcn.tf-vcn.id
  route_table_id = oci_core_route_table.tf-public-rt.id
}

resource "oci_core_subnet" "tf-private-subnet" {
  cidr_block     = "10.0.0.0/24"
  compartment_id = oci_identity_compartment.tf-compartment.id
  display_name   = "sandbox-private-subnet"
  #   dns_label                  = "sandboxprisnet"
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

  ingress_security_rules {
    source      = oci_core_vcn.tf-vcn.cidr_block
    source_type = "CIDR_BLOCK"
    stateless   = false
    protocol    = 6 # Protocol numbers: 1=ICMP, 6=TCP, 17=UDP
    tcp_options {
      max = 22
      min = 22
    }

  }

  ingress_security_rules {
    source      = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    stateless   = false
    protocol    = 1 # Protocol numbers: 1=ICMP, 6=TCP, 17=UDP
    icmp_options {
      code = 4
      type = 3
    }
  }

  ingress_security_rules {
    source      = oci_core_vcn.tf-vcn.cidr_block
    source_type = "CIDR_BLOCK"
    stateless   = false
    protocol    = 1 # Protocol numbers: 1=ICMP, 6=TCP, 17=UDP
    icmp_options {
      type = 3
    }
  }
}
