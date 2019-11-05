#!/usr/bin/env bash
echo "==> Nomad Client Deployment"

echo "--> Fetching"
install_from_url "nomad" "${nomad_url}"
sleep 10

echo "--> Create a Directory to Use as a Mount Target"
sudo mkdir -p /opt/mysql/data/
sudo mkdir -p /opt/mongodb/data/
sudo mkdir -p /opt/prometheus/data/

echo "--> Writing Configuration"
sudo mkdir -p /mnt/nomad
sudo mkdir -p /etc/nomad.d
sudo tee /etc/nomad.d/config.hcl > /dev/null <<EOF
name         = "${node_name}"
data_dir     = "/mnt/nomad"
enable_debug = true
bind_addr = "0.0.0.0"
datacenter = "${datacenter}"
region = "global"
enable_syslog  = "true"
advertise {
  http = "$(public_ip):4646"
  rpc  = "$(public_ip):4647"
  serf = "$(public_ip):4648"
}
client {
  enabled = true
  server_join {
    retry_join = ["provider=aws tag_key=nomad_join tag_value=${nomad_join}"]
  }
  meta {
    "type" = "worker",
    "name" = "${node_name}"
  }
  host_volume "mysql_mount" {
    path      = "/opt/mysql/data"
    read_only = false
  }
  host_volume "mongodb_mount" {
    path      = "/opt/mongodb/data"
    read_only = false
  }
  host_volume "prometheus_mount" {
    path      = "/opt/prometheus/data/"
    read_only = false
  }
}
plugin "raw_exec" {
  config {
    enabled = true
  }
}
plugin "docker" {
  config {
    allow_privileged = false
  }
}
autopilot {
    cleanup_dead_servers = true
    last_contact_threshold = "200ms"
    max_trailing_logs = 250
    server_stabilization_time = "10s"
    enable_redundancy_zones = false
    disable_upgrade_migration = false
    enable_custom_upgrades = false
}
EOF

echo "--> Writing profile"
sudo tee /etc/profile.d/nomad.sh > /dev/null <<"EOF"
export NOMAD_ADDR="http://${node_name}.node.consul:4646"
EOF
source /etc/profile.d/nomad.sh

echo "--> Generating systemd configuration"
sudo tee /etc/systemd/system/nomad.service > /dev/null <<EOF
[Unit]
Description=Nomad Client
Documentation=https://www.nomadproject.io/docs/
Requires=network-online.target
After=network-online.target

[Service]
ExecStart=/usr/local/bin/nomad agent -config="/etc/nomad.d"
ExecReload=/bin/kill -HUP $MAINPID
KillSignal=SIGINT
Restart=on-failure
LimitNOFILE=65536

[Install]
WantedBy=multi-user.target
EOF

echo "--> Starting nomad"
sudo systemctl enable nomad
sudo systemctl start nomad

echo "--> Waiting for Nomad leader"
while [ -z "$(curl -s http://localhost:4646/v1/status/leader)" ]; do
  sleep 5
done

echo "==> Nomad Client is Installed!"

