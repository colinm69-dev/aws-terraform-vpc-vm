output "vpc_id" {
  description = "ID of the VPC."
  value       = aws_vpc.main.id
}

output "public_subnet_id" {
  description = "ID of the public subnet."
  value       = aws_subnet.public.id
}

output "instance_id" {
  description = "ID of the VM."
  value       = aws_instance.vm.id
}

output "instance_public_ip" {
  description = "Public IP of the VM."
  value       = aws_instance.vm.public_ip
}

output "ssh_command" {
  description = "Command to connect to the VM."
  value       = "ssh ubuntu@${aws_instance.vm.public_ip}"
}
