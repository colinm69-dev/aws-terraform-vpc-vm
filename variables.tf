variable "region" {
  description = "AWS region to deploy into."
  type        = string
  default     = "eu-west-2"
}

variable "project_name" {
  description = "Short name used for resource names and tags."
  type        = string
  default     = "lab"
}

variable "environment" {
  description = "Environment label used in tags."
  type        = string
  default     = "dev"
}

variable "availability_zone" {
  description = "Availability zone for the subnets. Must belong to var.region."
  type        = string
  default     = "eu-west-2a"
}

variable "enable_flow_logs" {
  description = "Send VPC flow logs to CloudWatch (small cost; recommended outside throwaway labs)."
  type        = bool
  default     = false
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR for the public subnet (hosts the VM)."
  type        = string
  default     = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
  description = "CIDR for the private subnet (no internet route; placeholder for databases etc.)."
  type        = string
  default     = "10.0.2.0/24"
}

variable "instance_type" {
  description = "EC2 instance type. Check your account's free-tier eligibility."
  type        = string
  default     = "t3.micro"
}

variable "root_volume_size_gb" {
  description = "Root EBS volume size in GiB."
  type        = number
  default     = 8
}

variable "admin_cidr" {
  description = "Your public IP in CIDR form (for example 203.0.113.7/32). Only this range can SSH in."
  type        = string

  validation {
    condition     = can(cidrhost(var.admin_cidr, 0)) && var.admin_cidr != "0.0.0.0/0"
    error_message = "admin_cidr must be a valid CIDR and must not be 0.0.0.0/0."
  }
}

variable "ssh_public_key" {
  description = "Contents of your SSH public key (for example the output of: cat ~/.ssh/id_ed25519.pub)."
  type        = string
}

variable "enable_http" {
  description = "Open TCP 80 to the internet (for a test web server)."
  type        = bool
  default     = false
}
