provider "aws" {
  region = "us-east-1"
}

# VPC
resource "aws_vpc" "main_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "main-vpc"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "main-igw"
  }
}

# Public Subnet
resource "aws_subnet" "main_subnet" {
  vpc_id                 = aws_vpc.main_vpc.id
  cidr_block             = "10.0.1.0/24"
  availability_zone      = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "main-subnet"
  }
}

# Route Table
resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "main-rt"
  }
}

# Route Table Association
resource "aws_route_table_association" "rta" {
  subnet_id     = aws_subnet.main_subnet.id
  route_table_id = aws_route_table.rt.id
}

# Security Group
resource "aws_security_group" "allow_ssh" {
  vpc_id = aws_vpc.main_vpc.id

  ingress {
    from_port  = 22
    to_port    = 22
    protocol   = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port  = 80
    to_port    = 80
    protocol   = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port  = 443
    to_port    = 443
    protocol   = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port  = 0
    to_port    = 0
    protocol   = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow-ssh"
  }
}

# Jenkins Master Instance
resource "aws_instance" "jenkins_master" {
  ami          = "ami-0a0e5d9c7acc336f1"
  instance_type = "t2.micro"
  subnet_id    = aws_subnet.main_subnet.id
  key_name     = "ASH-LATEST"
  security_groups = [aws_security_group.allow_ssh.id]

  tags = {
    Name = "JenkinsMaster"
  }
}

# Kubernetes Master Instance
resource "aws_instance" "kubernetes_master" {
  ami          = "ami-0a0e5d9c7acc336f1"
  instance_type = "t2.medium"
  subnet_id    = aws_subnet.main_subnet.id
  key_name     = "ASH-LATEST"
  security_groups = [aws_security_group.allow_ssh.id]

  tags = {
    Name = "KubernetesMaster"
  }
}

# Kubernetes Slave Instance
resource "aws_instance" "kubernetes_slave" {
  ami          = "ami-0a0e5d9c7acc336f1"
  instance_type = "t2.micro"
  subnet_id    = aws_subnet.main_subnet.id
  key_name     = "ASH-LATEST"
  security_groups = [aws_security_group.allow_ssh.id]

  tags = {
    Name = "KubernetesSlave"
  }
}
