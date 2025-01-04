terraform {
    backend "s3" {
        bucket = "upgd-bcknd-143"
        key = "terraform.tfstate"
        region = "us-east-1"
    }
}