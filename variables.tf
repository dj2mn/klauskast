variable "image" {
  description = "Image to use for Linode instance"
  default = "linode/debian10"
}
variable "token" {
  description = "Linode API Personal Access Token"
}
variable "root_pass" {
  description = "Root password for instance"
}
variable "authorized_keys" {
  description = "SSH keys for instance"
}
variable "owncast_stackscript_data" {
  description = "Map of required StackScript UDF data."
  type = map(string)
}
variable "region" {
  description = "Linode region"
}
variable "owncast_config" {
  description = "config data for owncast server"
  type = map(string)
}
variable "object_storage_access_key" {
  description = "access key for linode object storage"
}
variable "object_storage_secret_key" {
  description = "secret key for linode object storage"
}
