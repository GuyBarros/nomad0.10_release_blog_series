job "cni-deployment" {
  datacenters = ["eu-west-2","ukwest","sa-east-1","ap-northeast-1","dc1"]
  type = "batch"
  constraint {
    operator  = "distinct_hosts"
    value     = "true"
  }
  group "cni-deployments"{
    count = 3
    task "cni-install" {
      driver = "raw_exec"
      template {
        data = <<EOH
echo "--> Installing CNI plugin"
whoami
mkdir -p /opt/cni/bin/
wget -O cni.tgz https://github.com/containernetworking/plugins/releases/download/v0.8.2/cni-plugins-linux-amd64-v0.8.2.tgz
tar -xzf cni.tgz -C /opt/cni/bin/
EOH
        destination = "cni_install.sh"
        perms = "755"
      }
      config {
        command = "bash"
        args    = ["cni_install.sh"]
      }
    }
  }
}