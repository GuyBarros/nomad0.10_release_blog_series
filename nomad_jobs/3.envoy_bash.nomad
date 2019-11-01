job "envoy-deployment" {
  datacenters = ["eu-west-2","ukwest","sa-east-1","ap-northeast-1","dc1"]
  type = "batch"
  constraint {
    operator  = "distinct_hosts"
    value     = "true"
  }
  group "envoy-deployments"{
    count = 3
    task "envoy-install" {
      driver = "raw_exec"
      template {
        data = <<EOH
echo "--> Install Envoy"
curl -sL 'https://getenvoy.io/gpg' | apt-key add -
add-apt-repository \
"deb [arch=amd64] https://dl.bintray.com/tetrate/getenvoy-deb \
$(lsb_release -cs) \
stable"
apt-get update && apt-get install -y getenvoy-envoy
envoy --version
echo "--> Envoy Install Complete"
EOH
        destination = "envoy_install.sh"
        perms = "755"
      }
      config {
        command = "bash"
        args    = ["envoy_install.sh"]
      }
    }
  }
}