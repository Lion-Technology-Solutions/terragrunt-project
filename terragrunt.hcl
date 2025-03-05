 remote_state {
  backend = "s3"
  config = {
    bucket         = "class26-demo" # Replace with your S3 bucket name
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = "ca-central-1"
    encrypt        = true
    dynamodb_table = "my-lock-table" # Replace with your DynamoDB table name for state locking
  }
}

generate "provider" {
  path = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
provider "aws" {
  region = "ca-central-1" # Replace with your desired AWS region
}
EOF
}

inputs = {
  aws_region = "ca-central-1"
}