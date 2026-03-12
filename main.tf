# CloudEngine Labs - Terraform Infrastructure

terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

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

resource "aws_security_group" "flask_app_sg" {
  name        = "flask-app-security-group"
  description = "Allow SSH and Flask app traffic"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Flask App"
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

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
