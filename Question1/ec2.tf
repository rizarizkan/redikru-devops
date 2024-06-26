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
