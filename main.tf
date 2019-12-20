# define a variable called instance_count but dont provide a default so that user will be prompted to provide
variable "region" {
    default = "us-east-2"
    }

variable "name_description" { 
    default = "notDefined"
    }
variable "instance_type" { 
    default = "t2.nano"
    }
variable "instance_count" { }
variable "requester" {
  default = "g3sporter"
}

variable "size" {
  default = "small"
}
locals {
  size = {
    small = {"count"="2", "instance"="t2.micro"},
    med = {"count"="4", "instance"="t2.medium"},
    large = {"count"="4", "instance"="t2.large"}
 }
}
    
#variable "size" {
#    description = "size of instances"
#    default = {"name_description"="medium_ones","instance_type"="t2.micro"}
#    small = {"name_description"="small_ones","instance_type"="t2.small"
#}

# Use the AWS provider and deploy resources in us-east-2 region
provider "aws" {
  region = var.region
}


# create a number of EC2 instances
resource "aws_instance" "my_instance" {
  #count = local.size[$var.size].count
   
    count = local.size[var.size].count
    
  # The amazon machine image number (only valid in us-east-2)
  ami = "ami-0d8f6eb4f641ef691"
  # The instance size
    
   instance_type = local.size[var.size].instance
  
    
  #instance_type = "t2.micro"
  # Specify this block of tags on the resource
  tags = {
    # set the tag key: "Name"  = "g3sporter-1". Adding 1 to count.index because it starts at zero
    Name = "${var.requester}-${count.index + 1}"
  }
}

# Create an output with instance name and IP address
output "instance_ids" {
  # create a list of private_ip addresses of each instance
  value = aws_instance.my_instance[*].private_ip
}
