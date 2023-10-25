#!/usr/bin/bash
#<UDF name="server_hostname" label="Your public hostname for your Owncast server. Required for SSL." example="owncast.example.com" default="">
#<UDF name="email_address" label="Your email address for configuring SSL." example="me@example.com" default="info@only1klaus.com">
#<UDF name="owncast_home" label="Owncast home directory" example="/opt/owncast" default="/opt/owncast">
#<UDF name="storage_volume" label="Linode storage volume" example="owncast-storage" default="owncast-storage">
#<UDF name="stream_key" label="Owncast stream key" example="abc123" default="abc123">
#<UDF name="zabbix_server" label="zabbix server address" example="12.34.56.78">

## REQUIRED IN EVERY MARKETPLACE SUBMISSION
# Add Logging to /var/log/stackscript.log for future troubleshooting
exec 1> >(tee -a "/var/log/stackscript.log") 2>&1
# System Updates updates
apt-get -o Acquire::ForceIPv4=true update -y
## END OF REQUIRED CODE FOR MARKETPLACE SUBMISSION

MY_IP=$( ip -br -4 addr show eth0 | tr -s ' ' '/' | cut -d/ -f3 )

# Install zabbix
# apt-get install -y zabbix-agent rsync
# mv /etc/zabbix/zabbix_agentd.conf /etc/zabbix/zabbix_agentd.conf.bak
# cat > /etc/zabbix/zabbix_agentd.conf <<EOF
# PidFile=/var/run/zabbix/zabbix_agentd.pid
# LogFile=/var/log/zabbix-agent/zabbix_agentd.log
# LogFileSize=0
# Server=${ZABBIX_SERVER}
# #ServerActive=127.0.0.1
# SourceIP=${MY_IP}
# Include=/etc/zabbix/zabbix_agentd.conf.d/*.conf
# EOF
# systemctl restart zabbix-agent

# Add owncast user
adduser owncast --disabled-password --gecos ""

# Install dependencies
apt-get install -y libssl-dev unzip curl

# Mount storage volume
# mkfs.ext4 "/dev/disk/by-id/scsi-0Linode_Volume_$STORAGE_VOLUME"
mkdir -p "$OWNCAST_HOME" 
# mount "/dev/disk/by-id/scsi-0Linode_Volume_$STORAGE_VOLUME" "$OWNCAST_HOME"
# cat >> /etc/fstab <<EOF
# /dev/disk/by-id/scsi-0Linode_Volume_${STORAGE_VOLUME} ${OWNCAST_HOME} ext4 defaults,noatime,nofail 0 2
# EOF

# Install Owncast
cd "$OWNCAST_HOME"

curl -s https://owncast.online/install.sh | bash
chown -R owncast:owncast "$OWNCAST_HOME"

ln -s /opt/owncast/owncast/data/logs/owncast.log /var/log/owncast.log

# su - owncast -c "curl https://owncast.online/install.sh |bash"
# Setup Owncast as a systemd service
cat > /etc/systemd/system/owncast.service <<EOF
[Unit]
Description=Owncast
[Service]
Type=simple
User=owncast
Group=owncast
WorkingDirectory=${OWNCAST_HOME}/owncast
ExecStart=${OWNCAST_HOME}/owncast/owncast -streamkey ${STREAM_KEY} -logdir /var/log/owncast
Restart=on-failure
RestartSec=5
[Install]
WantedBy=multi-user.target
EOF

sudo systemd daemon-reload
# Start Owncast
systemctl enable owncast
systemctl start owncast

# Install Caddy
apt-get install -y debian-keyring debian-archive-keyring apt-transport-https
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | sudo apt-key add -
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' | sudo tee -a /etc/apt/sources.list.d/caddy-stable.list
apt update
apt-get install caddy

# Configure Caddy for HTTPS proxying
if [ -n "$SERVER_HOSTNAME" ]; then

  cat > /etc/caddy/Caddyfile <<EOF
  ${SERVER_HOSTNAME} {
    reverse_proxy 127.0.0.1:8080
    encode gzip
    tls ${EMAIL_ADDRESS}
  }
EOF
  # Start Caddy
  systemctl enable caddy
  systemctl start caddy
else
    echo "Server hostname not specified.  Skipping Caddy/SSL install."
fi

# Add MOTD
cat > /etc/motd <<EOF

 #######  ##      ## ##    ##  ######     ###     ######  ######## 
##     ## ##  ##  ## ###   ## ##    ##   ## ##   ##    ##    ##    
##     ## ##  ##  ## ####  ## ##        ##   ##  ##          ##    
##     ## ##  ##  ## ## ## ## ##       ##     ##  ######     ##    
##     ## ##  ##  ## ##  #### ##       #########       ##    ##    
##     ## ##  ##  ## ##   ### ##    ## ##     ## ##    ##    ##    
 #######   ###  ###  ##    ##  ######  ##     ##  ######     ##    

For help and documentation visit: https://owncast.online/docs

EOF

echo "Owncast setup complete! Access your instance at https://${SERVER_HOSTNAME} or http://$(hostname -I | cut -f1 -d' '):8080 if you have not configured your DNS yet."