Terraform Configuration

1. create file provider.tf that contains
This file configures the AWS provider.
          
          
                provider "aws" {
                  region = "us-east-1"
                }
          
2. vpc.tf
This file defines the VPC and the public subnet.
          
                resource "aws_vpc" "main" {
                  cidr_block = "10.0.0.0/16"
                  tags = {
                    Name = "MyVPC"
                  }
                }
                
                resource "aws_subnet" "public" {
                  vpc_id            = aws_vpc.main.id
                  cidr_block        = "10.0.1.0/24"
                  map_public_ip_on_launch = true
                  availability_zone = "us-east-1a"
                  tags = {
                    Name = "PublicSubnet"
                  }
                }
                
                resource "aws_internet_gateway" "gw" {
                  vpc_id = aws_vpc.main.id
                  tags = {
                    Name = "MyIGW"
                  }
                }
                
                resource "aws_route_table" "public" {
                  vpc_id = aws_vpc.main.id
                  route {
                    cidr_block = "0.0.0.0/0"
                    gateway_id = aws_internet_gateway.gw.id
                  }
                  tags = {
                    Name = "PublicRouteTable"
                  }
                }
                
                resource "aws_route_table_association" "a" {
                  subnet_id      = aws_subnet.public.id
                  route_table_id = aws_route_table.public.id
                }
          

3. security_group.tf
This file defines the security group to allow SSH access.
          
                resource "aws_security_group" "ssh" {
                  vpc_id = aws_vpc.main.id
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
                  tags = {
                    Name = "AllowSSH"
                  }
                }
          
4. ec2.tf
This file defines the EC2 instance.
                resource "aws_key_pair" "deployer" {
                  key_name   = "deployer-key"
                  public_key = file("~/.ssh/id_rsa.pub")
                }
                
                resource "aws_instance" "ubuntu" {
                  ami             = "ami-0a91cd140a1fc148a"  # Ubuntu Server 20.04 LTS (HVM), SSD Volume Type - Free tier eligible
                  instance_type   = "t2.micro"
                  subnet_id       = aws_subnet.public.id
                  security_groups = [aws_security_group.ssh.name]
                  key_name        = aws_key_pair.deployer.key_name
                
                  tags = {
                    Name = "MyUbuntuInstance"
                  }
                
                  connection {
                    type        = "ssh"
                    user        = "ubuntu"
                    private_key = file("~/.ssh/id_rsa")
                    host        = self.public_ip
                  }
                
                  provisioner "remote-exec" {
                    inline = [
                      "sudo apt-get update",
                      "sudo apt-get install -y nginx",
                    ]
                  }
                }

5. s3.tf
This file defines the S3 bucket.
          
                resource "aws_s3_bucket" "b" {
                  bucket = "my-s3-bucket-${random_string.bucket_suffix.result}"
                  acl    = "private"
                
                  tags = {
                    Name        = "MyS3Bucket"
                    Environment = "Dev"
                  }
                }
                
                resource "random_string" "bucket_suffix" {
                  length  = 6
                  special = false
                }
          



6. Deploying the Infrastructure
          
          1. terraform init
          2. terraform plan
          3. terraform apply
          
          The above Terraform configuration creates:
          
          A VPC with a CIDR block of 10.0.0.0/16.
          A public subnet with a CIDR block of 10.0.1.0/24.
          An internet gateway and route table to enable internet access for the subnet.
          An EC2 instance running Ubuntu with SSH access configured.
          An S3 bucket with a unique name.
          Ensure you have your SSH key (~/.ssh/id_rsa.pub) ready and configured correctly for SSH access to the EC2 instance. The terraform apply command will output the public IP of the EC2 instance and the name of the S3 bucket.
