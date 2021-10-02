image = "linode/debian10"
region = "ap-south"
type = "g6-standard-4"
owncast_domain_id = 431866 #replace with your own domain id
gitlab_domain_id = 140907
owncast_stackscript_data = {
   "email_address" = "info@only1klaus.com"
   "server_hostname" = "live2.only1klaus.net"
   "owncast_home" = "/opt/owncast"
   "storage_volume" = "owncast-storage"
   "stream_key" = "flange-rage-twisty"
}

docker_stackscript_data = {
   "email_address" = "stewart@f8.com.au"
   "server_hostname" = "gitlab.f8.com.au"
   "gitlab_home" = "/opt/gitlab"
   "storage_volume" = "gitlab-storage"
}
