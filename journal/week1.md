# Terraform Beginner Bootcamp 2023 - Week 1

## Fixing Tags

[How to Delete Local and Remote Tags on Git](https://devconnected.com/how-to-delete-local-and-remote-tags-on-git/)

Locall delete a tag
```sh
git tag -d <tag_name>
```

Remotely delete tag

```sh
git push --delete origin tagname
```

Checkout the commit that you want to retag. Grab the sha from your Github history.

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

[Homework]

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

[Homework: document this functionality for terraform cloud]


### Terraform variables order of operations

[Homework: document the order of precendence for terraform variables]

#### Considerations for using variable with Terraform Cloud

You can set two different types of variables in Terraform cloud
- Environment Variables - those you would normally set in your bash termianl
- Terraform Varaibles - Those that you would normally set in the terraform.tfvars file

When using terraform cloud the variable will need to be created in the web portal. They do not carry over form the local instance and the tfvars file is not uploaded to the cloud tool automatically. **These need to be defined as Terraform variables instead of environment variables.**

![Terraform Cloud Variable](/journal/screenshots/tf-cloud-var-ss.png)

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
