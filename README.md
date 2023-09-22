# **Terraform Beginner Bootcamp 2023**

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

### **Refactoring int Bash Scripts**

While ficing the Terraform CLI gpg deprecation issues noticed the bash scripts were considerably larger than the previous instructions. Decided to create a bash script to install the terraform CLI.

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

### **Gitpod Lifecycle (Before, Init, Command)**

We need to be careful when using init because it will not re-run for an existing workspace that has been restarted.

[Gitpod Lifecycle](https://www.gitpod.io/docs/configure/workspaces/tasks)

### **Working with Environment Variables (Env Vars)**

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

#### **Printing Env Vars**

We can print a env var by using echo

eg:
```sh
echo $HELLO
```

#### Scoping of Env Vars

When you open up a new bash terminal, it will not be aware of env vars that are set in another terminal.

If you want env vars to persist across all terminals, you need to set env vars in your bash profile so they are aware globally. eg: .bash_Profile

#### Persisting Env Vars in GitPod

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