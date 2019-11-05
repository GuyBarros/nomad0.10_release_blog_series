output "Servers_SSH" {
  value = module.nomad_aws_cluster.servers
}

output "Servers_UI" {
  value = module.nomad_aws_cluster.servers_ui
}

output "Workers_SSH" {
  value = module.nomad_aws_cluster.workers
}