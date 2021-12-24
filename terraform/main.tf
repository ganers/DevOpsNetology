# Configure the AWS Provider
provider "aws" {
  region = "eu-north-1"
}

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

data "aws_ami" "ubuntu" {
  most_recent      = true
  owners           = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = local.web_instance_type_map[terraform.workspace]
  
  count = local.web_instance_count_map[terraform.workspace]

}

resource "aws_instance" "web-fe" {
  for_each = local.instances
  ami = each.value
  instance_type = each.key

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_vpc" "my_vpc" {
  cidr_block = "172.16.0.0/16"

  tags = {
    Name = "tf-example"
  }
}

resource "aws_subnet" "my_subnet" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "172.16.10.0/24"
  availability_zone = "eu-north-1a"

  tags = {
    Name = "tf-example"
  }
}

resource "aws_network_interface" "foo" {
  subnet_id   = aws_subnet.my_subnet.id
  private_ips = ["172.16.10.100"]

  tags = {
    Name = "primary_network_interface"
  }
}

#resource "aws_eip" "lb" {
#  instance = aws_instance.web.id
#  vpc      = true
#}

locals {
  web_instance_type_map = {
    stage = "t3.micro"
    prod = "t3.large"
  }

  web_instance_count_map = {
    stage = 1
    prod = 2
  }

  instances = {
    "t3.micro" = data.aws_ami.ubuntu.id
    "t3.large" = data.aws_ami.ubuntu.id
  }
}
