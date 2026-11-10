# Latest Ubuntu 24.04 LTS AMI, resolved through Canonical's public SSM parameter.
data "aws_ssm_parameter" "ubuntu" {
  name = "/aws/service/canonical/ubuntu/server/24.04/stable/current/amd64/hvm/ebs-gp3/ami-id"
}

resource "aws_key_pair" "admin" {
  key_name   = "${var.project_name}-admin"
  public_key = var.ssh_public_key
}

resource "aws_instance" "vm" {
  #checkov:skip=CKV_AWS_88: Lab VM is reached over SSH from a single admin IP; a bastion or SSM would be the production pattern.
  #checkov:skip=CKV_AWS_126: Detailed monitoring is a paid feature and not needed for a lab.
  #checkov:skip=CKV2_AWS_41: The VM calls no AWS APIs, so no instance profile is attached (least privilege).
  ami                         = data.aws_ssm_parameter.ubuntu.value
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public.id
  vpc_security_group_ids      = [aws_security_group.vm.id]
  key_name                    = aws_key_pair.admin.key_name
  associate_public_ip_address = true
  monitoring                  = false # detailed monitoring is a paid feature
  ebs_optimized               = true

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required" # IMDSv2 only
    http_put_response_hop_limit = 1
  }

  root_block_device {
    volume_type           = "gp3"
    volume_size           = var.root_volume_size_gb
    encrypted             = true
    delete_on_termination = true
  }

  user_data = <<-EOT
    #!/bin/bash
    set -euo pipefail
    apt-get update -y
    apt-get upgrade -y
    apt-get install -y unattended-upgrades
    %{if var.enable_http~}
    apt-get install -y nginx
    echo "Provisioned by Terraform" > /var/www/html/index.html
    %{endif~}
  EOT

  user_data_replace_on_change = true

  tags = { Name = "${var.project_name}-vm" }
}
