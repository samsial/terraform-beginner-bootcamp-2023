output "bucket_name" {
    description = "Bucket name for our static website"
    value = module.home_home1.bucket_name
}

output "s3_website_endpoint" {
    description = "S3 Static Website hosting endpoint"
    value = module.home_home1.website_endpoint
}

output "cloudfront_url" {
    description = "cloudfront distribution domain name"
    value = module.home_home1.domain_name
}