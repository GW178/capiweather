# main.tf

provider "aws" {
  region = "eu-west-3"
}

variable "key_name" {}
variable "ami_id" {}
variable "key_path" {}

resource "aws_security_group" "jenkins_and_deploy_sg" {
  name        = "jenkins-and-deploy-sg"
  description = "Security group for Jenkins and Deployment instances"

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
    from_port   = 8080 # Jenkins UI port
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

  vpc_security_group_ids = [aws_security_group.jenkins_and_deploy_sg.id]
}

resource "aws_instance" "capiweather_jenkins_agent" {
  ami           = var.ami_id
  instance_type = "t2.micro"
  key_name      = var.key_name

  tags = {
    Name = "CW_Jenkins_Agent"
  }

  vpc_security_group_ids = [aws_security_group.jenkins_and_deploy_sg.id]
}

resource "aws_instance" "capiweather_deployment_server" {
  ami           = var.ami_id
  instance_type = "t2.micro"
  key_name      = var.key_name

  tags = {
    Name = "CW_Deployment_Server"
  }

  vpc_security_group_ids = [aws_security_group.jenkins_and_deploy_sg.id]
}

