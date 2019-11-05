# Module Configuration Variables
variable "region" {
  description = "The region to create your resourcesin."
}

variable "owner" {
  description = "The user who is managing the lifecycle of this cluster"
}

variable "created-by" {
  description = "Tag used to identify resources created programmatically by Terraform"
}

variable "public_key" {
  description = "The contents of the SSH public key to use for connecting to the cluster."
}

variable "clusterid" {
  description = "This is the deployment stage of the cluster. It should be unique for every cluster"
}

variable "host_access_ip" {
  description = "CIDR blocks allowed to connect via SSH on port 22"
}

variable "server_number" {
  description = "The number of servers for nomad leaders."
}

variable "server_instance_type" {
  description = "The type(size) for nomad leaders."
}

variable "worker_number" {
  description = "The number of servers for nomad workers."
}

variable "worker_instance_type" {
  description = "The type(size) for nomad workers."
}

variable "datacenter" {
  description = "The name you want to give the nomad datacenter"
}

# General Variables
variable "nomad_url" {
  description = "The url to download nomad."
}

variable "vpc_cidr_block" {
  description = "The top-level CIDR block for the VPC."
}

variable "cidr_blocks" {
  description = "The CIDR blocks to create the servers in."
}

variable "nomad_join" {
  description = "Nomad Auto-Join Tag Value"
}