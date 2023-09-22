# Terraform Beginner Bootcamp 2023

## Semantic Versioning :mage:

This project will use semantic versioning for it tagging
[semver.org](https://semver.org/)

The general format:

 **MAJOR.MINOR.PATCH**, eg `1.0.1`

- **MAJOR** version when you make incompatible API changes
- **MINOR** version when you add functionality in a backward compatible manner
- **PATCH** version when you make backward compatible bug fixes

## Install the Terraform CLI

## Considersations with the Terraform CLI changes
The Terraform CLI installation instructions have changed dur to GPG keyring changes. Needed to refere to the latest install instructions from terraform documentation and change the install script for the new instructions

[Install Terraform CLI](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)

### Considerations for Linux Distribution

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

### Refactoring int Bash Scripts

While ficing the Terraform CLI gpg deprecation issues noticed the bash scripts were considerably larger than the previous instructions. Decided to create a bash script to install the terraform CLI.

This bash script is located in: [./bin/install_terraform_cli](./bin/install_terraform_cli)

- This will keep the gitpod task file clean ([gitpod.yml(gitpod.yml)])
- This will allow an easier time to debug and execute manually terraform CLI install
- This will allow better portability for future projects that will use Terraform CLI

#### Shebang Considerations

A Shebang (pronounced Sha-bang) tells the bash script what interpreter will interpret the program eg: #!/bin/bash

ChatGPT recommended we use this format for bash `#!/usr/bin/env bash`

- for portability with different OS distributions
- will seach user's PATH for the bash executable

[shebang wikipedia](https://en.wikipedia.org/wiki/Shebang_(Unix))

#### Execution Considerations
When executing the bash script we can use the `./` shorthand notation to execute the bash script

eg: `./bin/install_terraform_cli`

If we are using a script in .gitpod.yml we need to point the script to a program to interpret it

eg: `source ./bin/install_terraform_cli`

#### Linux Permissions Considerations

To make our bash scripts executable we need to change linux permissions for the fix to be executable at the user mode.

```sh
chmod u+x ./bin/install_terraform_cli
```

Alternatively:

```sh
chmod 744 ./bin/install_terraform_cli
```
[chmod](https://en.wikipedia.org/wiki/Chmod)

### Gitpod Lifecycle (Before, Init, Command)

We need to be careful when using init because it will not re-run for an existing workspace that has been restarted.

[Gitpod Lifecycle](https://www.gitpod.io/docs/configure/workspaces/tasks)