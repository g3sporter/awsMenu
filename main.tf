variable "size" {
    description = "size of instances"
    default = {"name_description"="medium_ones","amount"="4"}
}

module "ec2_cluster" {
  source                 = "terraform-aws-modules/ec2-instance/aws"
  version                = "~> 2.0"

  name                   = var.size.name_description
  instance_count         = var.size.amount

  ami                    = "ami-ebd02392"
  instance_type          = "t2.micro"
  key_name               = "azc"
  subnet_id              = element(module.vpc.private_subnets,0)
  
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "azc-vpc-test"
  cidr = "10.0.0.0/16"

  azs             = ["us-east-2a"]
  private_subnets = ["10.0.1.0/24"]
  
  
  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}
