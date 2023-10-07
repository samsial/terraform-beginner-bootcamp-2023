# Terraform Beginner Bootcamp 2023 - Week 1

## Working with Ruby

### Sinatra Mock Server

[Sinatra Web Framework](https://sinatrarb.com/)

Sinatra is a micro web framework for Ruby to build web apps. It is great for mock/dev servers or very simple projects. It is possible to create a web server in a single file.

#### Bundler
`bundle exec` is how you bring packages into ruby. Packages in Ruby are known as "Gems"

We are using just a few gems located in the `/terratowns_mock_server/Gemfile`

#### Install Gems

```rb

source "https://rubygems.org"

gem 'sinatra'
gem 'rake'
gem 'pry'
gem 'puma'
gem 'activerecord'
```

Then you need to run the `bundle install` command
    - This installs the gems on the system globally.
    - This is different than like nodejs which installs packages in place in a folder.
    - A gemfile.lock will be created to lock down the gem version used in this project.

#### Executing Ruby Scripts in the contect of Bundler

We have to use `bundle exec` to tell future ruby scripts to use the gems we installed. This is the way to set contect in ruby.

### Running the Mock Server

We can run the web server by running the following commands:

```rb
bundle install
bundle exec ruby server.rb
```

All of the code for our server is stored in the `/terratowns_mock_server/server.rb` file.

### Somethings to note from the Mock Server

#### aXXXX error codes

custom aXXXX codes will help us isolate in our troubleshooting where an error may have occured. These are unique to this project and not something normally included. You want error codes to be kind of obfuscated in production environments to not give away to much information about what was wrong. Because we are learning here, these codes were implemented.

```rb
error 401, "a1002 Failed to authenicate, bearer token invalid and/or teacherseat_user_uuid invalid"
```
#### Params

Anytime the server.rb references the params() function, it is specifically talking about the body of the HTML (payload). We will send values to the server via JSON in the body that this function will parse out into the information it needs.

### ActiveModel

[ActiveModel Documentation](/terratowns_mock_server/server.rb)

[Active Model Basics](https://guides.rubyonrails.org/active_model_basics.html)


### HTML Error Code

[List of HTML Error Codes](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes)

### Bearer Authentication

[Bearer](https://swagger.io/docs/specification/authentication/bearer-authentication/)

## Creating a custom Terraform Provider

[Terraform Provider Documentation](https://developer.hashicorp.com/terraform/tutorials/providers)

This above link goes to a repo of documentation that will help us when writing custom terraform providers. There are several ways to write providers, choose the documentation that best fits your need.

### Terraformrc

This file allows us to use our custom provider and allow terraform to find it when it define it in the hcl. Since our provider wont be hosted on the official terraform registry, this file is required to load our local custom provider. 

We get this into the `/home/gitpod/.terraform.d/plugins/local.providers/local/` with the build_provider bash script in `/bin`.

### TF LOG

We can get more output for debugging when running Terraform commands by changing the log level. 

eg
```sh
TF_LOG=DEBUG tf init
```

### CRUD

Terraform Provider resources use CRUD. CRUD stands for:
    - Create
    - Read
    - Update
    - Delete

[CRUD from Wikipedia](https://en.wikipedia.org/wiki/Create,_read,_update_and_delete)

## Multi Home Refactor

We had to alter how our path to our static web content is given to the modules so that we could have more than one home.

### Steps to add a new home

- Add you home to the `terraform.tfvars.example` and the `terraform.tfvars` making sure to change the block for your new content
    ```tf
    YOURHOME = {
      public_path = "/workspace/terraform-beginner-bootcamp-2023/public/YOURHOMEDIRECTORY"
      content_version = 1 
    }
    ```
- Add you new module to `main.tf` making sure to change the block for your new content
    ```
    module "home_YOURHOME" {
      source = "./modules/terrahome_aws"
      user_uuid = var.teacherseat_user_uuid
      public_path = var.YOURHOME.public_path
      content_version = var.YOURHOME.content_version
    }
    ```
- Add your new resource to `main.tf` making sure to change the block for your new content
    ```
    resource "terratowns_home" "YOURHOME" {
      name = "French Onion Soup"
      description = <<DESCRIPTION
    YOURDESCRIPTION
    DESCRIPTION
      town = "TOWN"
      content_version = var.YOURHOME.content_version
      domain_name = module.YOURNEWMODULE.domain_name
    }
    ```
- Create a new directory under `./public` with your home name
    - Must include `index.html`
    - Must include `error.html`
    - Must include `/assets/`
        - **Only the top level of this directory will be uploaded. Sub-directories will be ignored**
- `tf init`
- `tf plan`
- `tf apply --auto-approve`