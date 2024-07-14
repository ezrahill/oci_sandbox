data "oci_core_images" "tf-images" {
  compartment_id           = oci_identity_compartment.tf-compartment.id
  operating_system         = "Canonical Ubuntu"
  operating_system_version = "22.04"
  sort_by                  = "TIMECREATED"
}


resource "oci_core_instance" "tf-ubuntu-instance" {
  availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
  compartment_id      = oci_identity_compartment.tf-compartment.id
  shape               = "VM.Standard.E2.1.Micro"
  source_details {
    source_id   = data.oci_core_images.tf-images.images[0].id
    source_type = "image"
  }

  display_name = "sandbox-ubuntu-instance"
  create_vnic_details {
    assign_public_ip = true
    subnet_id        = oci_core_subnet.tf-public-subnet.id
  }
  metadata = {
    ssh_authorized_keys = file(var.ssh_public_key_path)
  }
  preserve_boot_volume = false
}