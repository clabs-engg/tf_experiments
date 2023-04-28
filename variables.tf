variable "aws_region" {
  description = "The AWS region to use"
  type        = string
  validation {
    condition     = regex("^[a-z]{2}(-gov)?-(west|east|north|south|central)?-[0-9]", var.aws_region)
    error_message = "Invalid AWS region format. Expected format: <region-code>-<region-name>-<region-number>"
  }
  default = "us-east-1"
}

variable "vpc_id" {
  description = "The ID of the Virtual Private Cloud (VPC) to use"
  type        = string
  validation {
    condition     = regex("vpc-[a-f0-9]{8,17}", var.vpc_id)
    error_message = "Invalid VPC ID format. Expected format: vpc-xxxxxxxxxxxxxxxxx"
  }
}
variable "subnet_id" {
  description = "The ID of the subnet to use"
  type        = string
  validation {
    condition     = regex("subnet-[a-f0-9]{8,17}", var.subnet_id)
    error_message = "Invalid subnet ID format. Expected format: subnet-xxxxxxxxxxxxxxxxx"
  }
}

variable "ami_id" {
  description = "The ID of the Amazon Machine Image (AMI) to use"
  type        = string
  validation {
    condition     = regex("ami-[a-f0-9]{8,17}", var.ami_id)
    error_message = "Invalid AMI ID format. Expected format: ami-xxxxxxxxxxxxxxxxx"
  }
}

variable "instance_type" {
  type        = string
  description = "This variable decides which Instance Type to use"
}

variable "ssh_key" {
  type        = string
  description = "This variable decides which SSH Key to use"
}



