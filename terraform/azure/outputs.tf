output "servers" {
  value = "${formatlist("ssh %s@%s", var.admin_username, azurerm_public_ip.servers-pip[*].fqdn,)}"
}
