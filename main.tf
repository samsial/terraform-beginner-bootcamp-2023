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

module "home_home1" {
  source = "./modules/terrahome_aws"
  user_uuid = var.teacherseat_user_uuid
  public_path = var.home1.public_path
  content_version = var.home1.content_version
}

resource "terratowns_home" "home1" {
  name = "Indian Motorocylces"
  description = <<DESCRIPTION
Just a few pictures of some Indian Motorcycles!
DESCRIPTION
  town = "missingo"
  content_version = var.home1.content_version
  #domain_name = "test4231act.cloudfront.net"
  domain_name = module.home_home1.domain_name
}


module "home_frenchonionsoup" {
  source = "./modules/terrahome_aws"
  user_uuid = var.teacherseat_user_uuid
  public_path = var.frenchonionsoup.public_path
  content_version = var.frenchonionsoup.content_version
}

resource "terratowns_home" "frenchonionsoup" {
  name = "French Onion Soup"
  description = <<DESCRIPTION
This is my favorite French Onion Soup recipe.
DESCRIPTION
  town = "cooker-cove"
  content_version = var.frenchonionsoup.content_version
  domain_name = module.home_frenchonionsoup.domain_name
}