
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
