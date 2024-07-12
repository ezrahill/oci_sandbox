variable "tenancy_ocid" {
  description = "The OCID of the tenancy."
  type = string
}

variable "user_ocid" {
  description = "The OCID of the user."
  type = string
}

variable "private_key_path" {
  description = "The path to the private key."
  type = string
}

variable "fingerprint" {
  description = "The fingerprint of the public key."
  type = string
}

variable "region" {
  description = "The region."
  type = string
}