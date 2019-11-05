job "chat" {
  datacenters = ["dev-eu-west-2"]
  type = "service"
  group "anon_chat" {
    count = 1
     network {
              mode = "bridge"
              port "http" {
       static = 9002
    }
                }  
     task "anon_chat_server" {
      driver = "exec"
      artifact {
           source   = "https://github.com/GuyBarros/anonymouse-realtime-chat-app/blob/master/guychat?raw=true"
           destination = "local/repo/1/"
           mode = "file"        
         }
        env{
              "MONGODB_SERVER" = "127.0.0.1"
              "MONGODB_PORT" =   9999
              
          }
        config {
         
      command = "bash"
      args    = ["local/guychat"]
    }
    }
        service {
                name = "chat"
                tags = ["chat"]
                port = "http"
                 connect {
         sidecar_service {
           proxy {
             upstreams {
               destination_name = "mongodb"
               local_bind_port = 9999
             }
           }
         }
       }
            } 
  }
}
