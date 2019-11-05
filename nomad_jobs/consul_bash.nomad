job "consul-deployment" {
  datacenters = ["dev-eu-west-2","dc1"]
  type = "batch"
  constraint {
    operator  = "distinct_hosts"
    value     = "true"
  }
  group "consul-deployments"{
    count = 3
    task "consul-install" {
      driver = "raw_exec"
      template {
        data = <<EOH
echo "--> Installing Consul binary"
whoami
wget -O consul.zip https://releases.hashicorp.com/consul/1.6.1+ent/consul_1.6.1+ent_linux_amd64.zip
unzip consul.zip -d /usr/local/bin
EOH
        destination = "consul_install.sh"
        perms = "755"
      }
      config {
        command = "bash"
        args    = ["consul_install.sh"]
      }
    }
  }
}