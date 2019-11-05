# Module Configuration Variables
variable "region" {
  description = "The region to create your resources in."
  default     = "eu-west-2"
}

variable "owner" {
  description = "The user who is managing the lifecycle of this cluster"
}

variable "created-by" {
  description = "Tag used to identify resources created programmatically by Terraform"
  default     = "Terraform"
}

variable "public_key" {
  description = "The contents of the SSH public key to use for connecting to the cluster."
}

variable "clusterid" {
  description = "This is the deployment stage of the cluster. It should be unique for every cluster"
  default     = "dev-nomad"
}

variable "host_access_ip" {
  description = "CIDR blocks allowed to connect via SSH on port 22"
  default     = []
}

variable "server_number" {
  description = "The number of servers for nomad leaders."
  default     = "3"
}

variable "server_instance_type" {
  description = "The type(size) of data servers (consul, nomad, etc)."
  default     = "t2.medium"
}

variable "worker_number" {
  description = "The number of servers for nomad workers."
  default     = "3"
}

variable "worker_instance_type" {
  description = "The type(size) for nomad workers."
  default     = "t2.medium"
}

variable "datacenter" {
  description = "The name you want to give the nomad datacenter"
}

# General Variables
variable "nomad_url" {
  description = "The url to download nomad."
  default     = "https://releases.hashicorp.com/nomad/0.10.0/nomad_0.10.0_linux_amd64.zip"
}

variable "vpc_cidr_block" {
  description = "The top-level CIDR block for the VPC."
  default     = "10.1.0.0/16"
}

variable "cidr_blocks" {
  description = "The CIDR blocks to create the servers in."
  default     = ["10.1.1.0/24", "10.1.2.0/24"]
}

variable "nomad_join" {
  description = "Nomad Auto-Join Tag Value"
  default     = "nomad_join"
}