provider "aws" {
  region = "eu-west-3"
}

variable "key_name" {}
variable "ami_id" {}
variable "key_path" {}

resource "aws_security_group" "capiweather_sg" {
  name        = "capiweather_sg"
  description = "Security group for the Jenkins, Deployment, and GitLab instances"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

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
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "capiweather_jenkins_master" {
  ami           = var.ami_id
  instance_type = "t2.micro"
  key_name      = var.key_name

  tags = {
    Name = "CW_Jenkins_Master"
  }

  vpc_security_group_ids = [aws_security_group.capiweather_sg.id]
}

resource "aws_instance" "capiweather_jenkins_agent" {
  ami           = var.ami_id
  instance_type = "t2.micro"
  key_name      = var.key_name

  tags = {
    Name = "CW_Jenkins_Agent"
  }

  vpc_security_group_ids = [aws_security_group.capiweather_sg.id]
}

resource "aws_instance" "capiweather_deployment_server" {
  ami           = var.ami_id
  instance_type = "t2.micro"
  key_name      = var.key_name

  tags = {
    Name = "CW_Deployment_Server"
  }

  vpc_security_group_ids = [aws_security_group.capiweather_sg.id]
}

resource "aws_instance" "capiweather_gitlab_server" {
  ami           = var.ami_id
  instance_type = "t3.micro"
  key_name      = var.key_name

  tags = {
    Name = "CW_GitLab_Server"
  }

  vpc_security_group_ids = [aws_security_group.capiweather_sg.id]
}

output "jenkins_master_ip" {
  value = aws_instance.capiweather_jenkins_master.public_ip
}

output "jenkins_agent_ip" {
  value = aws_instance.capiweather_jenkins_agent.public_ip
}

output "deployment_server_ip" {
  value = aws_instance.capiweather_deployment_server.public_ip
}

output "gitlab_server_ip" {
  value = aws_instance.capiweather_gitlab_server.public_ip
}

