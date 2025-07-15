output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.webapp.id
}

output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.webapp.public_ip
}

output "public_ssh_key" {
  description = "Public WebApp ssh key"
  value = aws_key_pair.webapp_key.public_key
}