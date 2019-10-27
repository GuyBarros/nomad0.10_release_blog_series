##############################################################################
# Variables File
# 
# Here is where we store the default values for all the variables used in our
# Terraform code. If you create a variable with no default, the user will be
# prompted to enter it (or define it via config file or command line flags.)

variable "resource_group" {
  description = "The name of your Azure Resource Group."
  default     = "Azure-Nomad-Demo"
}

variable "demo_prefix" {
  description = "This prefix will be included in the name of some resources."
  default     = "nomad10"
}

variable "hostname" {
  description = "VM hostname. Used for local hostname, DNS, and storage-related names."
  default     = "nomad10"
}

variable "location" {
  description = "The region where the virtual network is created."
  default     = "centralus"
}

variable "virtual_network_name" {
  description = "The name for your virtual network."
  default     = "vnet"
}

variable "address_space" {
  description = "The address space that is used by the virtual network. You can supply more than one address space. Changing this forces a new resource to be created."
  default     = "10.0.0.0/16"
}

variable "subnet_prefix" {
  description = "The address prefix to use for the subnet."
  default     = "10.0.10.0/24"
}

variable "storage_account_tier" {
  description = "Defines the storage tier. Valid options are Standard and Premium."
  default     = "Standard"
}

variable "storage_disk_size" {
  description = "Defines the OS disk size. minimum is 70"
  default     = "100"
}

variable "storage_replication_type" {
  description = "Defines the replication type to use for this storage account. Valid options include LRS, GRS etc."
  default     = "LRS"
}

variable "vm_size" {
  description = "Specifies the size of the virtual machine."
  default     = "Standard_D4_v3"
}

variable "image_publisher" {
  description = "Name of the publisher of the image (az vm image list)"
  default     = "Canonical"
}

variable "image_offer" {
  description = "Name of the offer (az vm image list)"
  default     = "UbuntuServer"
}

variable "image_sku" {
  description = "Image SKU to apply (az vm image list)"
  default     = "16.04-LTS"
}

variable "image_version" {
  description = "Version of the image to apply (az vm image list)"
  default     = "latest"
}

variable "admin_username" {
  description = "Administrator user name"
  default     = "admin"
}

variable "admin_password" {
  description = "Administrator password"
  default     = "replace-with-your-password"
}

variable "servers" {
  description = "The number of data servers (consul, nomad, etc)."
  default     = "3"
}

variable "owner" {
description = "IAM user responsible for lifecycle of cloud resources used for training"
}

variable "created-by" {
description = "Tag used to identify resources created programmatically by Terraform"
default     = "Terraform"
}

variable "TTL" {
description = "Hours after which resource expires, used by reaper. Do not use any unit. -1 is infinite."
default     = "240"
}

variable "subscription_id" {
description = "your subscription ID for Vault KMS Auto Unseal"
}

variable "tenant_id" {
description = "your tenant ID for Vault KMS Auto Unseal"
}

variable "client_id" {
description = "your client ID for Vault KMS Auto Unseal"
}

variable "client_secret" {
description = "your client ID for Vault KMS Auto Unseal"
}

variable "namespace" {
description = "Namespace"
default     = "nomad10"
}

variable "nomad_url" {
  description = "The url to download nomad."
  default     = "https://releases.hashicorp.com/nomad/0.10.0-rc1/nomad_0.10.0-rc1_linux_amd64.zip"
}


variable "cni_plugin_url" {
  description = "The url to download teh CNI plugin for nomad."
  default     = "https://github.com/containernetworking/plugins/releases/download/v0.8.2/cni-plugins-linux-amd64-v0.8.2.tgz"
}

 variable "nomad_join_tag_name"{
  description = "The Resource tag name that nomad will look for in order to do Auto Join"
  default     = "Nomad"

 }  
 variable "nomad_join_tag_value"{
  description = "The Resource tag value that nomad will look for in order to do Auto Join"
  default     = "0.10demo"
  
 }

