# **Terraform Beginner Bootcamp 2023**

## Table of Contents
- [Semantic Versioning :mage:](#semantic-versioning-mage)
- [Install the Terraform CLI](#install-the-terraform-cli)
  * [Considersations with the Terraform CLI changes](#considersations-with-the-terraform-cli-changes)
  * [Considerations for Linux Distribution](#considerations-for-linux-distribution)
  * [Refactoring Terraform CLI Bash Script](#refactoring-terraform-cli-bash-script)
    + [Shebang Considerations](#shebang-considerations)
    + [Execution Considerations](#execution-considerations)
    + [Linux Permissions Considerations](#linux-permissions-considerations)
- [Gitpod Lifecycle (Before, Init, Command)](#gitpod-lifecycle-before-init-command)
- [Working with Environment Variables (Env Vars)](#working-with-environment-variables-env-vars)
  * [Printing Env Vars](#printing-env-vars)
  * [Scoping of Env Vars](#scoping-of-env-vars)
  * [Persisting Env Vars in GitPod](#persisting-env-vars-in-gitpod)
- [AWS CLI Installation](#aws-cli-installation)
- [Terraform Basics](#terraform-basics)
  * [Terraform Registry](#terraform-registry)
  * [Terraform Console](#terraform-console)
  * [Terraform INIT](#terraform-init--terraform-init)
  * [Terraform PLAN](#terraform-plan--terrraform-plan)
  * [Terraform APPLY](#terraform-apply--terraform-apply)
  * [Terraform State Files](#terraform-state-files)
  * [Terraform init -upgrade](#terraform-init--upgrade--terraform-init--upgrade)
  * [Terraform Validate](#terraform-validate--terraform-validate)
  * [Terraform Destroy](#terraform-destroy--terraform-destroy)
  * [Terraform cloud](#terraform-cloud)
  * [Examples used for this project - Week 0](#examples-used-for-this-project-week-0)
- [AWS S3 Basics](#aws-s3-basics)
    + [Week 0 Random named S3 Bucket](#week-0-random-named-s3-bucket)
- [Issues with Terraform Cloud Login and Gitpod workspace](#issues-with-terraform-cloud-login-and-gitpod-workspace)
- [Terraform Alias](#terraform-alias)


</br>

## **Semantic Versioning** :mage:

This project will use semantic versioning for it tagging
[semver.org](https://semver.org/)

The general format:

 **MAJOR.MINOR.PATCH**, eg `1.0.1`

- **MAJOR** version when you make incompatible API changes
- **MINOR** version when you add functionality in a backward compatible manner
- **PATCH** version when you make backward compatible bug fixes

## **Install the Terraform CLI**

### **Considersations with the Terraform CLI changes**
The Terraform CLI installation instructions have changed dur to GPG keyring changes. Needed to refere to the latest install instructions from terraform documentation and change the install script for the new instructions

[Install Terraform CLI](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)

### **Considerations for Linux Distribution**

This project is built against Ubuntu. Needed to know this for Terraform installation instructions. Please consider your distribution and change accordingly for your distribution needs

[How to check OS version in Linux](https://www.cyberciti.biz/faq/how-to-check-os-version-in-linux-command-line/)

Example of OS Version Check:
```bash
$ cat /etc/os-release
PRETTY_NAME="Ubuntu 22.04.3 LTS"
NAME="Ubuntu"
VERSION_ID="22.04"
VERSION="22.04.3 LTS (Jammy Jellyfish)"
VERSION_CODENAME=jammy
ID=ubuntu
ID_LIKE=debian
HOME_URL="https://www.ubuntu.com/"
SUPPORT_URL="https://help.ubuntu.com/"
BUG_REPORT_URL="https://bugs.launchpad.net/ubuntu/"
PRIVACY_POLICY_URL="https://www.ubuntu.com/legal/terms-and-policies/privacy-policy"
UBUNTU_CODENAME=jammy
```

### **Refactoring Terraform CLI Bash Script**

While fixing the Terraform CLI gpg deprecation issues noticed the bash scripts were considerably larger than the previous instructions. Decided to create a bash script to install the terraform CLI.

This bash script is located in: [./bin/install_terraform_cli](./bin/install_terraform_cli)

- This will keep the gitpod task file clean ([gitpod.yml(gitpod.yml)])
- This will allow an easier time to debug and execute manually terraform CLI install
- This will allow better portability for future projects that will use Terraform CLI

#### **Shebang Considerations**

A Shebang (pronounced Sha-bang) tells the bash script what interpreter will interpret the program eg: #!/bin/bash

ChatGPT recommended we use this format for bash `#!/usr/bin/env bash`

- for portability with different OS distributions
- will seach user's PATH for the bash executable

[shebang wikipedia](https://en.wikipedia.org/wiki/Shebang_(Unix))

#### **Execution Considerations**
When executing the bash script we can use the `./` shorthand notation to execute the bash script

eg: `./bin/install_terraform_cli`

If we are using a script in .gitpod.yml we need to point the script to a program to interpret it

eg: `source ./bin/install_terraform_cli`

#### **Linux Permissions Considerations**

To make our bash scripts executable we need to change linux permissions for the fix to be executable at the user mode.

```sh
chmod u+x ./bin/install_terraform_cli
```

Alternatively:

```sh
chmod 744 ./bin/install_terraform_cli
```
[chmod](https://en.wikipedia.org/wiki/Chmod)

## **Gitpod Lifecycle (Before, Init, Command)**

We need to be careful when using init because it will not re-run for an existing workspace that has been restarted.

[Gitpod Lifecycle](https://www.gitpod.io/docs/configure/workspaces/tasks)

## **Working with Environment Variables (Env Vars)**

- We can list out all env var using the `env` command
- We can filter specific env vars using grep eg: `env var | grep AWS_`
- In terminal we can set using export eg: `export HELLO='world'`
- In the terminal we can set an env var temporarily when running a command by including it inline 

    eg:
    ```sh
    $ HELLO='world' ./bin/print_message
    ```

- Within a bash script, we can set the env var without using export

    eg:
    ```bash
    #!/usr/bin/bash

    HELLO='world'

    echo $HELLO
    ```

### **Printing Env Vars**

We can print a env var by using echo

eg:
```sh
echo $HELLO
```

### **Scoping of Env Vars**

When you open up a new bash terminal, it will not be aware of env vars that are set in another terminal.

If you want env vars to persist across all terminals, you need to set env vars in your bash profile so they are aware globally. eg: .bash_Profile

### **Persisting Env Vars in GitPod**

We can persist env vars in gitpod by storing them in gitpod secrets storage

eg:
```sh
gp env HELLO='world'
```

All future workstations launched will set the env vars for all bash terminals opened in those workspaces.

You can also set env vars in the `gitpod.yml` file, however, this can only contain non-sensitive env vars


## **AWS CLI Installation**

AWS CLI is installed for this project via the bash script [./bin/install_aws_cli](./bin/install_aws_cli)

[Getting Started Install (AWS CLI)](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)

- This project is Ubuntu - x86
- We use the Linux - x86 installation instructions. 
- Please verify your OS and make changes necesary if you are on another OS

[AWS CLI Env Vars](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-envvars.html)

We can check if our AWS credentials are configured correctly by running the following CLI command

eg:
```sh
$ aws sts get-caller-identity
```
If it is succesful you should see a json payload return that looks like this:

```json
{
    "UserId": "UserID",
    "Account": "AccountNumber",
    "Arn": "arn:aws:iam::account:user/username"
}
```
Will need to generate AWS CLI credentials from IAM user in order to use the AWS CLI. 

We should use a unique user so we can limit permissions for this user in the future

Highly reccomend setting up MFA for you AWS environment. 

**Never publish your credentials in a file that will get pushed to github**

We used a gitpod secret env var for our AWS credentials so they will persist through workspaces and terminals, as well as keeping them in a secure storage.

## **Terraform Basics** 

### **Terraform Registry**

Terraform sources their providers and modules from the Terraform registry which is located at [registry.terrafor.io](https://registry.terraform.io/)

- Terraform Providers are interfaces to APIs that will allow the creation of resources in Terraform
- Terraform Modules are a way to make large amounts of Terraform modular, portable, and shareable
    - We write modules often in Terraform

### **Terraform Console**

We can see a list of all the Terraform commands by typing `terraform` in the terminal


### **Terraform INIT** | `terraform init`

At the start of a new Terraform project we run `terraform init` to download the binaries for the Terraform providers that the project will use,

When running Terraform INIT we get the message:

"Terraform has created a lock file .terraform.lock.hcl to record the provider
selections it made above. Include this file in your version control repository
so that Terraform can guarantee to make the same selections by default when
you run "terraform init" in the future."


Terraform init creates:

  - `.terraform` directory which contains our provider binaries
  - terraform.lock.hcl file
    - `terraform.lock.hcl` contains the locked versioning for the providers or modules that should be used with this project
    - This file **SHOULD** be included in your version controle commits

### **Terraform PLAN** | `terrraform plan`

This will generate a changeset about the state of our infrastructure and what will be changed.

Terraform plan creates the plan of what we are going to add, delete, modify. This works off previous state files to generate the plan based on what exists and what is defined in the terraform file.

Use `terraform plan -out` to save your plan to a file to gurantee that the displayed actions will be performed. This file can then be used in an `terraform apply` later. However, often outputting is ignored.

### **Terraform APPLY** | `terraform apply`

This will run a plan and pass the changeset to be executed by Terraform. Apply should prompt us to proceed. `Yes` is the only valid option to proceed, anything else will terminate the apply.

If you would like to automatically approve an apply, provide the auto approve flag to your apply command

eg: 
```terraform
terraform apply --auto-approve
```

### **Terraform State Files**

`terraform.tfstate` contains the information about the current state of your infrastructure.

This file **SHOULD NOT** be included in your version control commits

This file can containe sensitivie data. 

If this file is lost, you lose the knowledge about the state of your infrstructure.

`1terraform.tfstate.backup` is ther previous version of your state file

### **Terraform init -upgrade** | `terraform init -upgrade`

If you have ran `terraform init` and later add a new required provider. The terraform plan will likely display an error saying there is an inco0sistency in the lock file. This can be addressed by running `terraform init -upgrade` or also by re-running `terraform init`.

Error Example:
```sh
│ Error: Inconsistent dependency lock file
│ 
│ The following dependency selections recorded in the lock file are inconsistent with the current configuration:
│   - provider registry.terraform.io/hashicorp/aws: required by this configuration but no version is selected
│ 
│ To update the locked dependency selections to match a changed configuration, run:
│   terraform init -upgrade
```

### **Terraform Validate** | `terraform validate`

This will validate your terraform syntax to ensure there are no errors

### **Terraform Destroy** | `terraform destroy`

This will tear down (destroy) resources that were created by the `terraform apply` command. 

`terraform destroy --auto-approve` is valid to skip the confirmation prompt

### **Terraform cloud**

[Migrate State file from local to cloud](https://developer.hashicorp.com/terraform/tutorials/cloud/cloud-migrate)

```terraform
terraform {
  cloud {
    organization = "org"

    workspaces {
      name = "workspace_name"
    }
  }
}

```

### Examples used for this project - Week 0

[Terraform Random Provider](https://registry.terraform.io/providers/hashicorp/random/latest/docs)

This is a random provider created for pre-week (week0) so that we have soemthing to validate the initial week against for the bootcamp

This is an example of how to use a provider in your terraform file

eg:
```terraform
terraform {
  required_providers {
    random = {
      source = "hashicorp/random"
      version = "3.5.1"
    }
  }
}

provider "random" {
  # Configuration options
}
```

[Random String Documentation](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string)

This is an example of defining a resource 

eg:
```terraform
resource "random_string" "bucket_name" {
  length           = 16
  special          = true
  override_special = "/@£$"
}
```

[Terraform Outputs Documentation](https://developer.hashicorp.com/terraform/language/values/outputs)

This is an example of setting an output in the terraform file

eg:
```terraform
output "random_bucket_id" {
    value = random_string.bucket_name.id
}

output "random_bucket_result" {
    value = random_string.bucket_name.result
}
```

## **AWS S3 Basics**

#### **Week 0 Random named S3 Bucket**

[Bucket naming rules](https://docs.aws.amazon.com/AmazonS3/latest/userguide/bucketnamingrules.html?icmpid=docs_amazons3_console)

This comes into play with our random provider, given that by default the provider will use uppercase and some special characters that are invalid per AWS naming rules. On our initial apply to create the S3 bucket, the name was invalid causing an issue. 

We had to alter the resource to specify lowercase and to only use `.` or `-` special characters in the name per the AWS S3 bucket naming rules. We also increased the size to 32 characters.


## **Issues with Terraform Cloud Login and Gitpod workspace**

When trying to login to Terraform Cloud from gitpod, it will tyr to launch in gitpod bash terminal. You can CTRL+click the URL and generate a new token. Copy the token and hit `q` to exit the Terraform Cloud Wizard and right click to paste your token. 

If this doesnt work you can generate the authentication file yourself

```bash
touch /home/gitpod/.terraform.d/credentials.tfrc.json
open /home/gitpod/.terraform.d/credentials.tfrc.json
```

Place the following JSON in the opened file 
```json
{
  "credentials": {
    "app.terraform.io": {
      "token": "your-terraform-cloud-token"
    }
  }
}
```

We gave automated generating this token file using a bash script [.bin/generate_tfrc_credentials](./bin/generate_tfrc_credentials)

We also added a block to the gitpod.yml file to ensure this script is run **BEFORE** each gitpod workspace is established

```yml
    before: |
      source ./bin/install_terraform_cli
      source ./bin/generate_tfrc_credentials
```

## **Terraform Alias**

[Bash dotfiles](https://effective-shell.com/part-5-building-your-toolkit/managing-your-dotfiles/) - More information on bash dotfiles and how they can be used

Added bash script to [./bin/set_tf_alias](./bin/set_tf_alias) that will automatically set `alias tf="terraform"` in our ~/.bash_profile file each time our workspace is started.