# Terraform Beginner BOotcamp 2023 - Week 1

## Root Module Structre

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


https://developer.hashicorp.com/terraform/language/modules/develop/structure