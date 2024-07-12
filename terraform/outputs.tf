output "all-availability-domains-in-your-tenancy" {
  value = data.oci_identity_availability_domains.ads.availability_domains
}

output "compartment-name" {
  value = oci_identity_compartment.tf-compartment.name
}

output "compartment-OCID" {
  value = oci_identity_compartment.tf-compartment.id
}

output "vcn-name" {
  value = oci_core_vcn.tf-vcn.display_name
}

output "vcn-OCID" {
  value = oci_core_vcn.tf-vcn.id
}