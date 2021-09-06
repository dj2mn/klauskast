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
   script      = file("${path.module}/assets/stackscript.sh")
   is_public   = "false"
   rev_note    = "latest version"
}

resource "linode_instance" "owncast-server" {
    image = var.image
    label = "terraform-owncast"
    group = "Terraform"
    region = "ap-southeast"
    type = "g6-standard-1"
    authorized_keys = var.authorized_keys 
    root_pass = var.root_pass
    stackscript_id = linode_stackscript.owncast-setup.id
    stackscript_data = {
       "email_address" = var.stackscript_data["email_address"]
       "server_hostname" = var.stackscript_data["server_hostname"]
       "owncast_home" = var.stackscript_data["owncast_home"]
       "storage_volume" = var.stackscript_data["storage_volume"]
    }
}

resource "linode_volume" "owncast-storage" {
    label = var.stackscript_data["storage_volume"]
    region = "ap-southeast"
    size = "20"
    linode_id = linode_instance.owncast-server.id
    lifecycle {
      prevent_destroy = true
    }
}

resource "linode_domain_record" "owncast-endpoint" {
    domain_id   = 431866
    name        = "live"
    port        = 0
    priority    = 0
    record_type = "A"
    target      = linode_instance.owncast-server.ip_address
    ttl_sec     = 0
    weight      = 0
}
