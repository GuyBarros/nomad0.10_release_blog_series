terraform {
  required_version = ">= 0.12.0"
}

provider "aws" {
  version = "2.33"
  region  = var.region
}

module "nomad_aws_cluster" {
  source               = "./modules/aws"
  cidr_blocks          = var.cidr_blocks
  clusterid            = var.clusterid
  created-by           = var.created-by
  datacenter           = "${var.datacenter}-${var.region}"
  host_access_ip       = var.host_access_ip
  nomad_join           = var.nomad_join
  nomad_url            = var.nomad_url
  owner                = var.owner
  public_key           = var.public_key
  region               = var.region
  server_instance_type = var.server_instance_type
  server_number        = var.server_number
  vpc_cidr_block       = var.vpc_cidr_block
  worker_instance_type = var.worker_instance_type
  worker_number        = var.worker_number
}