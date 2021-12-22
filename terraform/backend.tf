terraform {
    backend "s3" {
        bucket = "terraform-states-netologydevops"
        encrypt = true
        key = "path/to/my/key"
        region = "eu-north-1"
        dynamodb_table = "terraform-locks"
    }
}