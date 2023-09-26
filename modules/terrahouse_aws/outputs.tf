#https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string
output "bucket_name" {
    description = "Bucket name for our static website"
    value = aws_s3_bucket.website_bucket.bucket
}

#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_website_configuration
output "website_endpoint" {
    value=aws_s3_bucket_website_configuration.website_configuration.website_endpoint
}