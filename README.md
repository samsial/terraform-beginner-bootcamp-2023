# **Terraform Beginner Bootcamp 2023**

## **Weekly Journals**

- [Week 0 Journal](/journal/week0.md)
- [Week 1 Journal](/journal/week1.md)
- [Week 2 Journal](/journal/week2.md)
- [Week 3 Journal](/journal/week3.md)

## Managing GIT Tags

https://docs.github.com/en/desktop/managing-commits/managing-tags-in-github-desktop

I forgot to `git pull` after `git checkout main` and tagged the wrong pull. I was able to fix this by deleting the tag on github and then re-opening gitpod on MAIN and re-doing the tagging process

## Dealing with Configuration Drfit

### What happens if we lose our state file?

If you lose your state file, you will likely have to tear down all your cloud infrastructure manually.

You can use Terraform import but it will not be available for all resources. You will need to check the documentation on the Terraform providers to determine which resources can be imported.

-- **Don't lose your state file**

### Fix Missing Resources with Terraform Import

https://developer.hashicorp.com/terraform/cli/import

[AWS S3 Bucket Import](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket#import)

`terraform import aws_s3_bucket.bucket bucket-name`

[Random String Terraform Import](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string#import)

`terraform import random_string.test test`

### Fix Manual Configuration

If someone makes a change through ClickOps(Manually), we can revert the resources to the desired state by re-running 
