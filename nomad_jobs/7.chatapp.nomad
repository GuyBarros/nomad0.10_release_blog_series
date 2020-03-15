job "chat-app" {
  datacenters = ["eu-west-2","ukwest","sa-east-1","ap-northeast-1","dc1","dc1-eu-west-2"]
  type = "service"
  group "chat-app" {
    count = 3

    update {
      max_parallel = 1
      health_check = "checks"
      min_healthy_time = "15s"
      healthy_deadline = "2m"
      # canary = 3
    }
    network {
      mode = "bridge"
      port "http" {
        to = 5000
      }
    }
    task "chat-app" {
      driver = "docker"
      config {
        image = "lhaig/anon-app:0.02"
      }
      env {
        "MONGODB_SERVER" = "127.0.0.1"
        "MONGODB_PORT" = "27017"
      }
      resources {
        cpu = 300 # MHz
        memory = 512 # MB
      }
    } # end chat-app task
    service {
      name = "chat-app"
      tags = ["urlprefix-/"]
      port = "http"
      check {
        name     = "chat-app alive"
        type     = "http"
        path     = "/chats"
        interval = "10s"
        timeout  = "2s"
      }
      connect {
        sidecar_service {
          tags = ["chat-app-proxy"]
          proxy {
            upstreams {
              destination_name = "mongodb"
              local_bind_port = 27017
            }
          }
        }
      } # end connnect
    } # end service
  } # end chat-app group
}