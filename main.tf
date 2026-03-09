# CloudEngine Labs - Terraform Infrastructure
# Provisions an AWS EC2 instance with Docker to run the Flask API

terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# AWS Provider configuration
provider "aws" {
  region = var.aws_region
}

# Get the latest Ubuntu 22.04 AMI
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Security Group allowing SSH and Flask app port
resource "aws_security_group" "flask_app_sg" {
  name        = "flask-app-security-group"
  description = "Allow SSH and Flask app traffic"

  # SSH access
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Flask app port
  ingress {
    description = "Flask App"
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "flask-app-sg"
    Project = "CloudEngineLabs-Assessment"
  }
}

# EC2 Instance
resource "aws_instance" "flask_app" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  vpc_security_group_ids      = [aws_security_group.flask_app_sg.id]
  key_name                    = var.key_name != "" ? var.key_name : null
  associate_public_ip_address = true

  user_data = base64encode(<<-EOF
#!/bin/bash
exec > /var/log/user-data.log 2>&1
apt-get update -y
apt-get install -y python3-pip
pip3 install flask
cat > /home/ubuntu/app.py << 'PYEOF'
from flask import Flask, jsonify
app = Flask(__name__)
@app.route("/")
def hello():
    return jsonify(message="Hello CloudEngine Labs - from Python Flask!")
if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
PYEOF
cd /home/ubuntu && nohup python3 app.py > /var/log/flask.log 2>&1 &
EOF
  )

  tags = {
    Name    = "flask-app-server"
    Project = "CloudEngineLabs-Assessment"
  }
}
