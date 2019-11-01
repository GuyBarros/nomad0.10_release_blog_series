job "consul-server" {
  datacenters = ["eu-west-2","ukwest","sa-east-1","ap-northeast-1","dc1"]
  type        = "system"
  group "consul-servers" {
    task "consul" {
      driver = "docker"
      config {
        force_pull   = true
        network_mode = "host"
        image        = "consul:1.6.1"
        command      = "consul"
        args         = ["agent", "-config-dir", "/consul/config"]
        volumes      = ["local/consul/server.hcl:/consul/config/server.hcl"]
      }

      template {
        data        = <<EOF
          log_level = "DEBUG"
          data_dir = "/consul/data"
          datacenter = "dc1"
          primary_datacenter = "dc1"
          enable_central_service_config = true
          server = true
          bootstrap_expect = 3
          retry_join = ["provider=aws tag_key=nomad_join tag_value=nomad_join"]
          bind_addr = "0.0.0.0"
          client_addr = "0.0.0.0"
          advertise_addr = "{{ env "attr.unique.network.ip-address" }}"
          ports {
              grpc = 8502
              http = 8500
          }
          connect {
              enabled = true
          }
          ui = true
          EOF
        destination = "local/consul/server.hcl"
      }
    }
  }
}
