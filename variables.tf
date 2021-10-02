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
variable "stackscript_data" {
  description = "Map of required StackScript UDF data."
  type = map(string)
}
variable "region" {
  description = "Linode region"
}
variable "type" {
  description = "Linode VM instance type"
}
variable "domain_id" {
  description = "Linode ID of domain A record to update"
}