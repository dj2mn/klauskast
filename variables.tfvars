region = "ap-south"

owncast_config = {
   "type" = "g6-standard-4"
   "domain_id" = "431866"
   "image" = "linode/debian10"
}
owncast_stackscript_data = {
   "email_address" = "info@only1klaus.com"
   "server_hostname" = "live.only1klaus.net"
   "owncast_home" = "/opt/owncast"
   "storage_volume" = "owncast-storage"
   "stream_key" = "flange-rage-twisty"
   "zabbix_server" = "home.f8.com.au"
}

gitlab_config = {
   "type" = "g6-standard-4"
   "domain_id" = "140907"
   "image" = "linode/debian10"
}
gitlab_stackscript_data = {
   "email_address" = "stewart@f8.com.au"
   "server_hostname" = "gitlab.f8.com.au"
   "gitlab_home" = "/opt/gitlab"
   "storage_volume" = "gitlab-storage"
}
