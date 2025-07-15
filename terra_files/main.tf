provider "aws" {
  region = var.region
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "WebApp-VPC"
  }
}

resource "aws_subnet" "public" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "eu-central-1a"
  tags = {
    Name = "Public-Subnet"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
}

resource "aws_key_pair" "webapp_key" {
  key_name   = "webapp-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCkjT0Yt6eoCpZ1cXySGEAInLEs3+IIylNZo7Tpsp0d0EaZgr6gWTBlxh9W1SLCGLX4WEG9u8F80rWCxSn2jpoug+ps3Hp2i3jS/T+iV+E4+TAbU4hFhAat1GbgB46fzEB8GXCvV7qs3fIK6Yq4Sv1qKFNtzIKypKdXXimBn1rHehrRk/7JA/6F0nSIfnIDxnU7B5anUEBnnVmOJHGfhE6uh+tk+gCOJSH0Xn0D7GbXrofGWM7jeVSRQTC+xuVsJ+rGS62bLEZy0xy/xB6HfZKU6iQdeLcYgS/QZZm2hchCvmoiDV4OhUgUqSDz5dNWl5iMk/rpXqp1nT+VuDcd7fe9CaIzQvWrrOgiA5tJgBQct0XLYEDlQqUs0ghiuaDS7eq06MM7YSI1xFQytkGhbLddJPq4kG7XJBZCE0PlFbtKmwPxwxyCJWAISTEsvmjtGpO+ehOjpIehiqUqS/yjVDm1d1HModcaLuwZic8NCYtBzFJNABlwHAIFkcgERGUwl5s= root@localhost.localdomain"  # Replace this
}

resource "aws_security_group" "webapp_sg" {
  name        = "webapp-security-group"
  description = "Allow HTTP/HTTPS and SSH"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Warning: Limit this in production!
  }

  ingress {
    from_port = 5000
    to_port   = 5000
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "webapp" {
  ami                    = "ami-01e70a605ecda527e" # Red Hat Enterprise Linux 10 (HVM)
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.webapp_sg.id]
  key_name               = aws_key_pair.webapp_key.key_name

  tags = {
    Name = "WebApp-Server"
  }
}
