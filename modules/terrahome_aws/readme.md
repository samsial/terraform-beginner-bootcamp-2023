## Terrafhome AWS

```tf
module "home_home1" {
  source = "./modules/terrahome_aws"
  user_uuid = var.teacherseat_user_uuid
  public_path = var.home1_public_path
  content_version = var.content_version
}
``````

The public directory expects the follow:
- index.html
- error.html
- assets/

All top level files in assets will be copied but not any subdirectories