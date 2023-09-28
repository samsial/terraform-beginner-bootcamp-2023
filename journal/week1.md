# Terraform Beginner Bootcamp 2023 - Week 1

## How to Fix a Tag

[Github Deleting Tags](https://devconnected.com/how-to-delete-local-and-remote-tags-on-git/)

Delete Tag Locally
```sh
git tag -d <tag_name>
```

Delete Tag Remotely

```sh
git push --delete origin tagname
```

Checkout the commit you want to add the tag to. You will need the SHA for that commit which can be found in the github repo

```sh
git checkout <SHA>
git tag M.M.P
git push --tags
git checkout main
```


## Root Module Structure

https://developer.hashicorp.com/terraform/language/modules/develop/structure

The root module structure is as follows:

```bash
PROJECT_ROOT
│
├── main.tf                 # everything else.
├── variables.tf            # stores the structure of input variables
├── terraform.tfvars        # the data of variables we want to load into our terraform project
├── providers.tf            # defined required providers and their configuration
├── outputs.tf              # stores our outputs
└── README.md               # required for root modules
```

### Moved from cloud to local state

We migrated back from a cloud deployment to a local deployment for Terraform. We will need to remember to destroy our cloud resources prior to closing the gitpod workspace each time. To migrate back we

- We ran `terraform destroy` top remove the infrastructure from week 0 that we had built with Terraform Cloud
- Deleted our terraform lock file
- Performed a new `terraform init`


### Terraform Input Variables

[Terraform Input variables](https://developer.hashicorp.com/terraform/language/values/variables)

#### Passing variable via the command in the CLI
You can pass the variable value in the `terraform plan` command by using the `-var` flag. The variables flag must come after the terraform command.

eg:
```bash
terraform plan -var user_uuid="12345678-1234-1234-1234-1234567890ab"
```

#### Terraform var-file flag

[Terraform -var-file Flag](https://developer.hashicorp.com/terraform/language/values/variables#variable-definitions-tfvars-files)

Instead of feeding a bunch of variables via the command line, it is much more convenient (and cleaner) to put the variables in a file that ends with `.tfvars` or `tfvars.json` and then feed that file on the command line. We can accomplish this with the `-var-file` flag when performing a terraform command.

eg:
```
terraform apply -var-file="testing.tfvars"
```

#### Passing variables via the `terraform.tfvars` file
Variables can also be supplied through the `terraform.tfvars` file. This method can also be used to override a pre-defined variable.

The format for this file is below:

```terraform
key="value"
```
eg:
```terraform
user_uuid="12345678-1234-1234-1234-1234567890ab"
```

#### Terraform auto.tfvars

[Terraform auto.tfvars File](https://developer.hashicorp.com/terraform/language/values/variables#variable-definitions-tfvars-files)

>Terraform also automatically loads a number of variable definitions files if they are present:
>
>Files named exactly terraform.tfvars or terraform.tfvars.json.
>Any files with names ending in .auto.tfvars or .auto.tfvars.json.
>Files whose names end with .json are parsed instead as JSON objects, with the root object properties corresponding to variable names:
>
>```
>{
>  "image_id": "ami-abc123",
>  "availability_zone_names": ["us-west-1a", "us-west-1c"]
>}
>
>```


### Terraform variables order of operations

[Homework: document the order of precendence for terraform variables]

Terraform loads input variables in a specific order which also determines their precedence. The later a variable is loaded, the more preferred it is. 

The order of loading is as follows:
- Environment Variables
- `terraform.tfvars` files
- `terraform.tfvars.json` files
- Any `*.auto.tfvars` or `*auto.tfvars.json` files
  - These files are loaded in [lexical](https://en.wikipedia.org/wiki/Lexicographic_order) of their filenames.
- Any `-var` or `-var-file` options from the command line.
  - These are loaded in the order in which they are provided on the CLI

#### Considerations for using variable with Terraform Cloud

You can set two different types of variables in Terraform cloud
- Environment Variables - those you would normally set in your bash termianl
- Terraform Varaibles - Those that you would normally set in the terraform.tfvars file

When using terraform cloud the variable will need to be created in the web portal. They do not carry over form the local instance and the tfvars file is not uploaded to the cloud tool automatically. **These need to be defined as Terraform variables instead of environment variables.**

![Terraform Cloud Variable](/journal/screenshots/tf-cloud-var-ss.png)

#### Terraform Cloud auto.tfvars and other considerations

[Terraform Cloud Variable COnsideration](https://developer.hashicorp.com/terraform/cloud-docs/workspaces/variables)

Because Terraform Cloud is executing our terraform on another compute platform, there are considerations to be aware of when using TF Cloud for execution. The precened now includes variables that are defined in the project as well as the workspace with a lightly different precedence. I am not using TF Cloud but this is a good reference for the future in case we move back to executing on the Terraform Cloud platform.

[Terraform Cloud Precedence - Note this is in reverse order from the Terraform Documentation](https://developer.hashicorp.com/terraform/cloud-docs/workspaces/variables#precedence)

### Terraform Regex Module

I couldnt see the entire regext string in the course work this week. I tried to duplicate it from past experience and by determining the format of a UUID. I forgot to add the string to test against and was getting a failure that said the var.user_uuid variable needed to be added. Regexg in TF is very close to the regext function in RHEL but during troubleshooting I confirmed with the below link.

[Terraform Regex Function](https://developer.hashicorp.com/terraform/language/functions/regex)

## Terraform Modules

[Terraform Modules Overview](https://developer.hashicorp.com/terraform/tutorials/modules/module)

### Terraform Module Structure

It is reccomended to place modules in a `modules` directory when locally developing modules. This file can be named anything but modules makes the most sense here for clarity. There is a standard module structure

[Terraform Module Structure](https://developer.hashicorp.com/terraform/language/modules/develop/structure)

eg minimal module:

```
tree minimal-module/
.
├── README.md
├── main.tf
├── variables.tf
├── outputs.tf
```

eg nested module:

```
tree complete-module/
.
├── README.md
├── main.tf
├── variables.tf
├── outputs.tf
├── ...
├── modules/
│   ├── nestedA/
│   │   ├── README.md
│   │   ├── variables.tf
│   │   ├── main.tf
│   │   ├── outputs.tf
│   ├── nestedB/
│   ├── .../
├── examples/
│   ├── exampleA/
│   │   ├── main.tf
│   ├── exampleB/
│   ├── .../
```

### Passing Input Variables

We cann pass input variables to a module through the root `main.tf`

```tf
module "terrahouse_aws" {
  user_uuid = var.user_uuid
  bucket_name = var.bucket_name
}
```

[Terraform Module Sources](https://developer.hashicorp.com/terraform/language/modules/sources)

There are several ways to source modules into the root `main.tf`. Relative path, absolute path, Terraform Registry, github direct path, etc.

eg (relative path):

```tf
module "terrahouse_aws" {
  source = "./modules/terrahouse_aws"
}
```


### Terraform Outputs with Nested Modules

Condsideration should be taken when using outputs with nested modules. The outputs are only visible within the module itself. If we want to have the outputs available at the root, we need to make reference in the root '`outputs.tf` to the output in the module.

eg:

```tf
output "bucket_name" {
    description = "Bucket name for our static website"
    value = module.terrahouse_aws.bucket_name                #notice here it calls the module as opposed to the resource
}
```


### Terraform Refresh

[Terraform Refresh Command](https://developer.hashicorp.com/terraform/cli/commands/refresh)

This is drepcated but there is a new way to refresh with `terraform apply -refresh-only -auto-approve`

## Considerations when using ChatGPT to write Terraform

LLMs, such as ChatGPT, may not be trained on the latest information or documentation about Terraform.

It may produce innacurate examples that are deprecated and no longer accurate. This can affect an example used from ChatGPT causing errors when used since the version on Terraform is further along that what ChatGPT knows about.

## Working with Files in Terraform

[Special Path Varaible](https://developer.hashicorp.com/terraform/language/expressions/references#filesystem-and-workspace-info)

In terraform there is a special variaable called `path` that allows us to reference local paths:
- path.module -- get the path for the current module
- path.root -- get the path for the root module

## Static Website Hosting

### AWS Static Website Hosting Resource

[AWS S3 Website Configuration Resource](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_website_configuration)

### AWS S3 Object

[AWS S3 Object Resource](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_object)

### Terraform etags

Terrraform by default does not look at the data in a static file. It only looks at if the resource has changed or the location, etc. 

To add content changes to the resource checking within terraform we use eTAGs. In this example, we use the MD5 Terraform function to create a hash of the `index.html` file. The bleow example will create and MD5 hash of our index.html file which will change anytime we change the content in the file. This will cause Terraform to see a change and the re-upload the file to the S3 bucket with the new static HTML included.

ed:

```tf
etag = filemd5(var.index_html_filepath)
```

[md5 Function](https://developer.hashicorp.com/terraform/language/functions/md5)

### Terraform Functions

There are a plethora of functions that we can use.

[Terraform Functions](https://developer.hashicorp.com/terraform/language/functions)


## CDN Implementation

### Cloudfront Disribution 

[CloudFront Distribution Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_distribution)

Cloudfront is AWS version of a Content Delivery Network ([CDN](https://en.wikipedia.org/wiki/Content_delivery_network)). We uses Cloudfront distributions to tell Cloudfront where we want our content delivered to users from.

[More Details on Cloudfront Distribution](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/distribution-overview.html)

### Origin Access Control

Origin Access Control is the new more feature rich way to provide access to an AWS S3 bucket. Origin Access Identity was the previous way and is much more tedious to implement. There were also certain situations where OAI was not supported.

>CloudFront provides two ways to send authenticated requests to an Amazon S3 origin: origin access control (OAC) and origin access identity (OAI). We recommend using OAC because it supports:
>
>All Amazon S3 buckets in all AWS Regions, including opt-in Regions launched after December 2022
>
>Amazon S3 server-side encryption with AWS KMS (SSE-KMS)
>
>Dynamic requests (PUT and DELETE) to Amazon S3
>
>OAI doesn't work for the scenarios in the preceding list, or it requires extra workarounds in those scenarios. The following topics describe how to use OAC with an Amazon S3 origin. For information about how to migrate from OAI to OAC, see Migrating from origin access identity (OAI) to origin access control (OAC).

[AWS Cloudfront Article on Origin Access Control](https://aws.amazon.com/blogs/networking-and-content-delivery/amazon-cloudfront-introduces-origin-access-control-oac/)

[Terraform Origin Access Control Resource](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_origin_access_control)

[AWS OAC Walkthrough](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/private-content-restricting-access-to-s3.html)

### Terraform Locals Values

[Terraform Locals Values](https://developer.hashicorp.com/terraform/language/values/locals)

Locals allows us to define local variables. This can be used to consume data that needs to be transformed into another format and then referenced in somewhere else.

**locals** not local

eg:

```tf
locals {
    s3_origin_id = "MyS3Origin"                       # Defined the Local Variable
}

resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name              = 
    origin_access_control_id = 
    origin_id                = local.s3_origin_id     ## Consumed the local variable
  }
}
```

### AWS Bucket Policy

[AWS Bucket Policy Terraform Resource](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy)

[AWS Bucket Policy Documentation](https://docs.aws.amazon.com/AmazonS3/latest/userguide/example-bucket-policies.html)

Bucket Policies are used to secure access to your AWS S3 Buckets.

### Terraform Data Sources

[Terraform Data Sources](https://developer.hashicorp.com/terraform/language/data-sources)

This allow us to source data from cloud resources. This is usefull when we want to reference cloud resources without importing them.

eg:
```tf
resource "aws_s3_bucket_policy" "allow_access_from_another_account" {
  bucket = aws_s3_bucket.example.id
  policy = data.aws_iam_policy_document.allow_access_from_another_account.json      # data. calls the data block below
}

data "aws_iam_policy_document" "allow_access_from_another_account" {                # defines the cloud resource we want to reference above
  statement {
    principals {
      type        = "AWS"
      identifiers = ["123456789012"]
    }

    actions = [
      "s3:GetObject",
      "s3:ListBucket",
    ]

    resources = [
      aws_s3_bucket.example.arn,
      "${aws_s3_bucket.example.arn}/*",
    ]
  }
}
```


### Working with JSON

[Terraform JSON Encode](https://developer.hashicorp.com/terraform/language/functions/jsonencode)

eg:
```
> jsonencode({"hello"="world"})
{"hello":"world"}

```

[Terraform JSON Decode](https://developer.hashicorp.com/terraform/language/functions/jsondecode)

eg:
```
> jsondecode("{\"hello\": \"world\"}")
{
  "hello" = "world"
}
> jsondecode("true")
true
```

## Terraform Lifecycle 

[Terraform Lifecycle Documentation](https://developer.hashicorp.com/terraform/language/meta-arguments/lifecycle)

### Terraform Data

[Terraform Data](https://developer.hashicorp.com/terraform/language/resources/terraform-data)

In order to use local variables or plain data values to enact change on the `tf plan` we need a way to represent them as a resource that Terraform will see as changing. This resource also gives `lifecycle` something to look at to trigged a `replace_triggered_by` on a static resource like our `index.html`.

eg:
```tf
resource "terraform_data" "content_version" {
  input = var.content_version
}

resource "aws_s3_object" "index_html" {
  bucket = aws_s3_bucket.website_bucket.bucket
  key    = "index.html"
  source = var.index_html_filepath
  content_type = "text/html"

  etag = filemd5(var.index_html_filepath)
  lifecycle {
    ignore_changes = [etag]
    replace_triggered_by = [terraform_data.content_version.output]
  }
}
```
