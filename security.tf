resource "aws_security_group" "vm" {
  name        = "${var.project_name}-vm-sg"
  description = "Security group for the lab VM"
  vpc_id      = aws_vpc.main.id

  tags = { Name = "${var.project_name}-vm-sg" }
}

resource "aws_vpc_security_group_ingress_rule" "ssh_admin" {
  security_group_id = aws_security_group.vm.id
  description       = "SSH from admin IP only"
  cidr_ipv4         = var.admin_cidr
  ip_protocol       = "tcp"
  from_port         = 22
  to_port           = 22
}

resource "aws_vpc_security_group_ingress_rule" "http" {
  count = var.enable_http ? 1 : 0

  security_group_id = aws_security_group.vm.id
  description       = "HTTP from anywhere (test web server)"
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tcp"
  from_port         = 80
  to_port           = 80
}

resource "aws_vpc_security_group_egress_rule" "https_out" {
  security_group_id = aws_security_group.vm.id
  description       = "HTTPS out (package mirrors, APIs)"
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tcp"
  from_port         = 443
  to_port           = 443
}

resource "aws_vpc_security_group_egress_rule" "http_out" {
  security_group_id = aws_security_group.vm.id
  description       = "HTTP out (apt mirrors)"
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tcp"
  from_port         = 80
  to_port           = 80
}

resource "aws_vpc_security_group_egress_rule" "dns_out" {
  security_group_id = aws_security_group.vm.id
  description       = "DNS to the VPC resolver"
  cidr_ipv4         = var.vpc_cidr
  ip_protocol       = "udp"
  from_port         = 53
  to_port           = 53
}
