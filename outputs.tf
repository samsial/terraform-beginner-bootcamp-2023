#https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string
output "random_bucket_name" {
    value = aws_s3_bucket.website_bucket
}