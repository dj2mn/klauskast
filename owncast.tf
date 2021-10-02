terraform {
  required_providers {
    linode = {
      source = "linode/linode"
      version = "1.16.0"
    }
  }
}

provider "linode" {
  token = var.token
}

resource "linode_stackscript" "owncast-setup" {
   label       = "owncast-setup"
   images      = ["linode/debian10"]
   description = "deploy owncast streaming server"
   script      = file("${path.module}/assets/stackscript-owncast.sh")
   is_public   = "false"
   rev_note    = "latest version"
}

resource "linode_instance" "owncast-server" {
    image = var.image
    label = "owncast-server"
    group = "Terraform"
    region = "ap-south"
    type = var.type
    authorized_keys = var.authorized_keys 
    root_pass = var.root_pass
    stackscript_id = linode_stackscript.owncast-setup.id
    stackscript_data = {
       "email_address" = var.owncast_stackscript_data["email_address"]
       "server_hostname" = var.owncast_stackscript_data["server_hostname"]
       "owncast_home" = var.owncast_stackscript_data["owncast_home"]
       "storage_volume" = var.owncast_stackscript_data["storage_volume"]
       "stream_key" = var.owncast_stackscript_data["stream_key"]
    }
}

# data "linode_object_storage_cluster" "primary" {
#     id = "ap-south-1"
# }
# resource "linode_object_storage_bucket" "owncast-storage" {
#   cluster = data.linode_object_storage_cluster.primary.id
#   label = "%s"
# }

resource "linode_domain_record" "owncast-endpoint" {
    domain_id   = var.owncast_domain_id
    name        = "live"
    port        = 0
    priority    = 0
    record_type = "A"
    target      = linode_instance.owncast-server.ip_address
    ttl_sec     = 120
    weight      = 0
}

output "public_ip" {
  value = linode_instance.owncast-server.ip_address
}
