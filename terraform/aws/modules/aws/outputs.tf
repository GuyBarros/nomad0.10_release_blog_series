output "servers" {
  value = "${formatlist("ssh -i ~/.ssh/hashi ubuntu@%s" ,aws_instance.nomad_server.*.public_dns)}"
}

output "servers_ui" {
  value = "${formatlist("http://%s:4646" ,aws_instance.nomad_server.*.public_dns)}"
}

output "workers" {
  value = "${formatlist("ssh -i ~/.ssh/hashi ubuntu@%s" ,aws_instance.nomad_worker.*.public_dns)}"
}
