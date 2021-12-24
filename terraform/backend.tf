terraform {
    backend "s3" {
        bucket = "terraform-states-netologydevops"
        encrypt = true
        key = "path/to/my/key"
        region = "eu-north-1"
        dynamodb_table = "terraform-locks"
    }
}

//terraform {
//  required_providers {
//    aws = {
//      source  = "hashicorp/aws"
//      version = "~> 3.0"
//    }
//  }
//  backend "s3" {
//    bucket = "netologytfstate"
//    key    = "state"
//    region = "eu-central-1"
//  }
//}