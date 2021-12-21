terraform {
    backend "s3" {
        bucket = "terraform-states-netologydevops"
        encrypt = true
        key = "main-infra/terraform.tfstate"
        region = "eu-north-1"
        dynamodb_table = "terraform-locks"
    }
}