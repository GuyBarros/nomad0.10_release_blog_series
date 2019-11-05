data "template_file" "server" {
  count = var.server_number
  template = "${join("\n", list(
    file("${path.root}/modules/templates/shared/base.sh"),
    file("${path.root}/modules/templates/servers/nomad.sh")
  ))}"
  vars = {
    region    = "${var.region}"
    datacenter = var.datacenter
    node_name = "${var.clusterid}-${random_id.nomad_cluster.hex}-svr-${count.index}"
    server_number = var.server_number
    nomad_url = var.nomad_url
    nomad_join = var.nomad_join
  }
}

# Gzip cloud-init config
data "template_cloudinit_config" "server" {
  count = var.server_number
  gzip          = true
  base64_encode = true
  part {
    content_type = "text/x-shellscript"
    content      = "${element(data.template_file.server.*.rendered, count.index)}"
  }
}

resource "aws_instance" "nomad_server" {
  count = var.server_number

  ami           = data.aws_ami.ubuntu.id
  instance_type = var.server_instance_type
  key_name      = aws_key_pair.nomad_ssh_key.id

  subnet_id              = "${element(aws_subnet.nomad_subnet.*.id, count.index)}"
  iam_instance_profile   = aws_iam_instance_profile.nomad_join.name
  vpc_security_group_ids = [aws_security_group.nomad_sg.id]
  root_block_device{
    volume_size           = "240"
    delete_on_termination = "true"
  }

  ebs_block_device  {
    device_name           = "/dev/xvdd"
    volume_type           = "gp2"
    volume_size           = "240"
    delete_on_termination = "true"
  }

  tags = {
    Name           = "${var.clusterid}-${random_id.nomad_cluster.hex}-svr-${count.index}"
    owner          = var.owner
    created-by     = var.created-by
    nomad_join     = var.nomad_join
  }

  user_data = "${element(data.template_cloudinit_config.server.*.rendered, count.index)}"
}