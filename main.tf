terraform {
  required_providers {
    terratowns = {
      source = "local.providers/local/terratowns"
      version = "1.0.0"
    }
  }
  cloud {
    organization = "andrewpaul13"
  
    workspaces {
      name = "terra-house-1"
    }
  }
}

#this is us using our custom provider. Notice the three things we defined in the schema in main.go are included here
#eg: endpoint, user_uuid, token
#these are hardcoded mock values for the local mock web server. When we do this for real it will use our uuid and token from ExamPro
provider "terratowns" {
  endpoint = "http://localhost:4567"
  user_uuid="e328f4ab-b99f-421c-84c9-4ccea042c7d1" 
  token="9b49b3fb-b8e9-483c-b703-97ba88eef8e0"
}

#module "terrahouse_aws" {
#  source = "./modules/terrahouse_aws"
#  user_uuid = var.user_uuid
#  bucket_name = var.bucket_name
#  index_html_filepath = var.index_html_filepath
#  error_html_filepath = var.error_html_filepath
#  content_version = var.content_version
#  assets_directory = var.assets_directory
#}