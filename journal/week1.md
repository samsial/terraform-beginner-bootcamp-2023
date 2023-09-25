# Terraform Beginner Bootcamp 2023 - Week 1

## Root Module Structre

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