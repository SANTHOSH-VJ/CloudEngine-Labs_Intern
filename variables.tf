# CloudEngine Labs - Terraform Variables

variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "docker_image" {
  description = "Docker image to deploy (format: username/image:tag)"
  type        = string
  # IMPORTANT: Replace with your Docker Hub image after pushing
  # Example: "yourusername/flask-cloudengine:latest"
}

variable "key_name" {
  description = "Name of the AWS key pair for SSH access (optional)"
  type        = string
  default     = ""
}
