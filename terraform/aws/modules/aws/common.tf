data "aws_availability_zones" "available" {}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_key_pair" "nomad_ssh_key" {
  key_name   = "${var.clusterid}-ssh-key-${random_id.nomad_cluster.hex}"
  public_key = var.public_key
}

resource "aws_iam_instance_profile" "nomad_join" {
  name = "${var.clusterid}-${random_id.nomad_cluster.hex}-nomad_join"
  role = aws_iam_role.nomad_join.name
}

resource "aws_iam_policy" "nomad_join" {
  name        = "${var.clusterid}-${random_id.nomad_cluster.hex}-nomad_join"
  description = "Allows Nomad nodes to describe instances for joining."

  policy = data.aws_iam_policy_document.nomad-server.json
}


resource "aws_iam_role" "nomad_join" {
  name               = "${var.clusterid}-${random_id.nomad_cluster.hex}-nomad_join"
  assume_role_policy = "${file("${path.root}/modules/templates/policies/assume-role.json")}"
}

resource "aws_iam_policy_attachment" "nomad_join" {
  name       = "${var.clusterid}-${random_id.nomad_cluster.hex}-nomad_join"
  roles      = [aws_iam_role.nomad_join.name]
  policy_arn = aws_iam_policy.nomad_join.arn
}

data "aws_iam_policy_document" "nomad-server" {

  statement {
    effect = "Allow"

    actions = [
      "ec2:DescribeInstances",
    ]
    resources = ["*"]
  }

}