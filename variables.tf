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
