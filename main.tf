#AWS S3 Bucket Naming rules
#https://docs.aws.amazon.com/AmazonS3/latest/userguide/bucketnamingrules.html?icmpid=docs_amazons3_console
resource "random_string" "bucket_name" {
  length           = 32
  special          = false
  override_special = ".-"
  lower = true
  upper = false
}

#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket
resource "aws_s3_bucket" "example" {
  bucket = random_string.bucket_name.result

  tags = {
    UserUuid = var.user_uuid
  }
}