terraform {
  backend "s3" {}
}

# create VPC
resource "aws_vpc" "vpc" {
    cidr_block =  var.vpc_cidr 
    enable_dns_support = true 
    enable_dns_hostnames = true 
    tags  = merge(var.tags, {Name = "${var.name_prefix}-vpc"})
  
}

# Create subnet

resource "aws_subnet" "subnet" {

    vpc_id  =  aws_vpc.vpc.id  
    cidr_block =   var.subnet.cidr  
    availability_zone = var.availability_zone
    map_public_ip_on_launch = true 
    tags  = merge(var.tags, {Name = "${var.name_prefix}-subnet"})
}

# Create Security group 

resource "aws_security_group" "sg" {
    vpc_id   = aws_vpc.vpc.vpc_id
    name =  "${var.name_prefix}-sg"

    #ALLOW SSH ACCESS

    ingress {
        from_port   = 22 
        to_port    = 22 
        protocol  = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    # ALLOW HTTP ACCESS
    ingress {
        from_port   = 80 
        to_port  = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
  
}
# create EC2 INSTANCE

resource "aws_instance" "ec2" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.subnet.id
  vpc_security_group_ids = [aws_security_group.sg.id]
  key_name               = var.key_name
  tags                   = merge(var.tags, { Name = "${var.name_prefix}-ec2" })

root_block_device {
    volume_size = var.root_volume_size
    volume_type = var.root_volume_type
  }

}