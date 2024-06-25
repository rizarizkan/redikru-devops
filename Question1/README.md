Deploying the Infrastructure

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
