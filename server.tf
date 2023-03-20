terraform {

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

variable "aws_region" {
  type    = string
  default = "us-west-2"
}


# Configure the AWS Provider
provider "aws" {
  region = var.aws_region
}

# This module that creates the VPC

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "terraform-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["us-west-2a", "us-west-2b", "us-west-2c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway   = false
  enable_vpn_gateway   = false
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name        = "Jenkins-vpc"
    Terraform   = "true"
    Environment = "dev"
  }
}

# Creates the security group and its rules for K8s Control plane (master node)

resource "aws_security_group" "jenkins_sg" {
  name        = "jenkins_sg"
  description = "Allow inbound traffic to Jenkins server"
  vpc_id      = module.vpc.vpc_id


  ingress {
    description = "Remote access with SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }


  ingress {
    description = "HTTP from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP from VPC"
    from_port   = 8080
    to_port     = 8080
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
    Name = "jenkins_sg"
  }

}


# Creates instance for Jenkins server
resource "aws_instance" "Jenkins-server" {

  ami           = "ami-0a97be4c4be6d6cc4"
  instance_type = "t2.medium"
  # count                       = 2
  key_name  = "k8s-intances"
  user_data = file("jenkins.sh")

  security_groups             = [aws_security_group.jenkins_sg.id, ]
  monitoring                  = true
  associate_public_ip_address = true
  subnet_id                   = module.vpc.public_subnets[0]


  # Customizes the default EBS to a specific size
  root_block_device {
    volume_size           = "30"
    volume_type           = "gp2"
    delete_on_termination = true
  }



  tags = {
    Name        = "Jenkins-server"
    "Terraform" = "true"
    Environment = "dev"
  }

  lifecycle {
    create_before_destroy = true
  }
}


