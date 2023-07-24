provider "aws" {
  region = "us-west-2"
}

resource "aws_security_group" "instance" {
  name = "camply_sg"

  ingress {
    from_port   = 5001
    to_port     = 5001
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

    ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.instance.id]
  key_name      = "camply_tf_key"

  tags = {
    Name = "FlaskAppServer"
  }

  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, world"
              cd /home/ubuntu
              sudo apt update -y
              sudo apt install -y python3-pip git
              sudo apt install python3.8-venv
              sudo apt install pipx
              pipx ensurepath
              source ~/.bashrc
              pipx install camply
              pipx ensurepath
              source ~/.bashrc
              pipx install camply
              export PATH=/root/.local/bin:$PATH
              # export env variables here
              echo "running camply"
              camply campsites     --rec-area 2803     --start-date 2023-08-11     --end-date 2023-08-13     --notifications Telegram     --search-forever
              EOF
}

output "public_ip" {
  value = aws_instance.web.public_ip
}

output "instance_id" {
  description = "The ID of the instance"
  value       = aws_instance.web.id
}
