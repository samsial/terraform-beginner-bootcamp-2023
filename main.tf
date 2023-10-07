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
  endpoint = var.terratowns_endpoint
  user_uuid = var.teacherseat_user_uuid
  token = var.terratowns_access_token
}

module "terrahouse_aws" {
  source = "./modules/terrahouse_aws"
  user_uuid = var.teacherseat_user_uuid
  index_html_filepath = var.index_html_filepath
  error_html_filepath = var.error_html_filepath
  content_version = var.content_version
  assets_directory = var.assets_directory
}

resource "terratowns_home" "home1" {
  name = "Indian Motorocylces"
  description = <<DESCRIPTION
Just a few pictures of some Indian Motorcycles!
DESCRIPTION
  town = "missingo"
  content_version = 1
  #domain_name = "test4231act.cloudfront.net"
  domain_name = module.terrahouse_aws.cloudfront_url
}