job "cni-deployment" {
  datacenters = ["dev-eu-west-2","dc1"]
  type = "batch"

  group "cni-deployments"{
    task "cni-download" {
      driver = "raw_exec"
      artifact {
        source      = "https://github.com/containernetworking/plugins/releases/download/v0.8.2/cni-plugins-linux-amd64-v0.8.2.tgz"
      }
      config {
        command = "cp"
        args = [" --parents","local/*", "/opt/bin/cni/"]
      }
    }
  }
}