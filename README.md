# klauskast

A terraform plan to deploy owncast streaming service for www.only1klaus.com on Linode hosting platform.

The following additional information will be needed to run this code. 

### file ./secrets.tfvars

```
token = "LINODE_API_TOKEN"
root_pass = "root password"
authorized_keys = [ "ssh-rsa AAAA...etc" ]
```

With that in place, running `terraform apply -vars-file=secrets.tfvars -vars-file=variables-tfvars` should create a server instance with a persistent storage volume, and update DNS entry.
