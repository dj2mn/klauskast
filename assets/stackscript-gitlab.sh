#!/bin/sh

## Install Docker:
wget -qO- https://get.docker.io/gpg | apt-key add -
echo deb http://get.docker.io/ubuntu docker main > /etc/apt/sources.list.d/docker.list
apt-get update	
apt-get -q -y --force-yes install lxc-docker

## Enable firewall:
ufw enable
ufw allow 22
ufw allow http