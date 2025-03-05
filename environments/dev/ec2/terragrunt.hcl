include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../modules/ec2-deployments"
}

inputs = {
  name_prefix       = "prod-ec2-deployment"
  vpc_cidr          = "10.0.0.0/16"
  subnet_cidr       = "10.0.1.0/24"
  availability_zone = "ca-central-1a"
  ami_id            = "ami-055943271915205db" # Replace with your AMI ID
  instance_type     = "t2.micro"
  key_name          = "march05"
  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}