job "fabio-deployment" {
  region = "global"
  datacenters = ["dev-eu-west-2","dc1-eu-west-2"]
  type     = "system"
  priority = 75
  update {
    stagger      = "10s"
    max_parallel = 1
  }
  task "fabio" {
    driver = "exec"
    config {
      command = "fabio"
    }
    artifact {
      source      = "https://github.com/fabiolb/fabio/releases/download/v1.5.12/fabio-1.5.12-go1.13.1-linux_amd64"
      destination = "fabio"
      mode        = "file"
    }
    service {
      port = "http"
      name = "fabio"
      check {
        type     = "http"
        port     = "ui"
        path     = "/health"
        interval = "10s"
        timeout  = "2s"
      }
    }
    resources {
      network {
        port "http" {
          static = 80
        }
        port "ui" {
        #   static = 9998
          static = 9998
        }
      }
    }
  }
}