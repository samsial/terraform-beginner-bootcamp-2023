terraform {
  required_providers {
    random = {
      source = "hashicorp/random"
      version = "3.5.1"
    }
    aws = {
      source = "hashicorp/aws"
      version = "5.17.0"
    }
  }
}

provider "aws" {
  # Configuration options
}

provider "random" {
  # Configuration options
}
#AWS S3 Bucket Naming rules
#https://docs.aws.amazon.com/AmazonS3/latest/userguide/bucketnamingrules.html?icmpid=docs_amazons3_console
resource "random_string" "bucket_name" {
  length           = 32
  special          = true
  override_special = ".-"
  lower = true
  upper = false
}

#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket
resource "aws_s3_bucket" "example" {
  bucket = random_string.bucket_name.result
  }

#https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string
output "random_bucket_name" {
    value = random_string.bucket_name.result
}