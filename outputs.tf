# CloudEngine Labs - Terraform Outputs

output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.flask_app.id
}

output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.flask_app.public_ip
}

output "instance_public_dns" {
  description = "Public DNS name of the EC2 instance"
  value       = aws_instance.flask_app.public_dns
}

output "flask_app_url" {
  description = "URL to access the Flask application"
  value       = "http://${aws_instance.flask_app.public_ip}:5000/"
}
