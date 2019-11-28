job "consul-deployment" {
  datacenters = ["eu-west-2","ukwest","sa-east-1","ap-northeast-1","dc1","dc1-eu-west-2"]
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
wget -O consul.zip https://releases.hashicorp.com/consul/1.6.2/consul_1.6.2_linux_amd64.zip
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