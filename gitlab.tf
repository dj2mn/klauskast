resource "linode_stackscript" "gitlab" {
   label       = "gitlab"
   images      = ["linode/debian10"]
   description = "deploy gitlab with docker"
   script      = file("${path.module}/assets/stackscript-gitlab.sh")
   is_public   = "false"
   rev_note    = "latest version"
}


resource "linode_instance" "gitlab-server" {
    image = var.gitlab_config["image"]
    label = "gitlab-server"
    group = "Terraform"
    region = "ap-south"
    type = var.gitlab_config["type"]
    authorized_keys = var.authorized_keys 
    root_pass = var.root_pass
    stackscript_id = linode_stackscript.gitlab.id
    stackscript_data = {
#        "email_address" = var.gitlab_stackscript_data["email_address"]
#        "server_hostname" = var.gitlab_stackscript_data["server_hostname"]
#        "gitlab_home" = var.gitlab_stackscript_data["gitlab_home"]
#        "storage_volume" = var.gitlab_stackscript_data["storage_volume"]
    }
}

resource "linode_volume" "gitlab-storage" {
    label = "gitlab"
    region = var.region
    size = "20"
    linode_id = linode_instance.gitlab-server.id
#     lifecycle {
#       prevent_destroy = true
#     }
}

resource "linode_domain_record" "gitlab" {
    domain_id   = var.gitlab_config["domain_id"]
    name        = "gitlab"
    port        = 0
    priority    = 0
    record_type = "A"
    target      = linode_instance.gitlab-server.ip_address
    ttl_sec     = 120
    weight      = 0
}

