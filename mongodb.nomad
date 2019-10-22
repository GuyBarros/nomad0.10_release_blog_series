job "mongodb" {
  datacenters = ["eu-west-2","ukwest","sa-east-1","ap-northeast-1","dc1"]
  type = "service"
  group "db" {
    count = 1
    volume "mongodb_vol" {
      type = "host"
      source = "mongodb_mount"
    }
    network {
      mode = "bridge"
    }
    task "mongodb" {
      driver = "docker"
      env {
        "MONGO_INITDB_ROOT_USERNAME" = "root"
        "MONGO_INITDB_ROOT_PASSWORD" = "example"
      }
      volume_mount {
        volume      = "mongodb_vol"
        destination = "/data/db"
      }
      config {
        mage = "mongo"
      }
  
      logs {
        max_files     = 5
        max_file_size = 15
      }
      resources {
        cpu = 500
        memory = 512
      } 
      
    }
    service {
      name = "mongodb"
      tags = ["mongodb"]
      port = "27017"
      connect {
        sidecar_service {}
      }
    }
  }
}
  