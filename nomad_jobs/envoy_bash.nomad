job "envoy-deployment" {
  datacenters = ["dev-eu-west-2","dc1"]
  type = "batch"

  group "envoy-deployments"{
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