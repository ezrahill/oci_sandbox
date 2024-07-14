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

output "image-name" {
  value = data.oci_core_images.tf-images.images[0].display_name
}

output "public-ip-for-compute-instance" {
  value = oci_core_instance.tf-ubuntu-instance.public_ip
}
