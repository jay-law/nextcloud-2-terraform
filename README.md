# Overview

This tutorial is designed to walk users through installing Nextcloud in AWS (Amazon Web Services) using Terraform and Ansible.  It's more of a working example opposed to an in-depth tutorial.

In the first part of the tutorial, Terraform will be used to:
- Create an EC2 instance
- Create security groups and assign them to the EC2 instance
- Create an elastic IP address and assign it to the EC2 instance
- Attach pem file to EC2 instance

In the second part of the tutorial, Ansible will be used to:
- Install and configure MySQL (database)
    - `roles/common/tasks/configure_database.yml`
- Install and configure Apache (web server)
    - `roles/common/tasks/configure_web.yml`
- Install and configure Nextcloud (application)
    - `roles/common/tasks/configure_nextcloud.yml` 
- Install a Nextcloud app
    - `roles/apps/tasks/main.yml`

Tested with the following:
- Local machine
    - Ubuntu 20.04.4 LTS (64-bit)
    - Terraform 1.1.6
    - Ansible (core) 2.12.2
    - Python 3.8.10
- Remote machine (AWS EC2 instance)
    - Ubuntu 20.04 LTS (64-bit)

**NOTE** Part of this documentation is copied from the previous tutorial (`nextcloud-1-terraform`).  Some sections can be skipped if they were already performed.  For example, Terraform doesn't need to be installed again.

# Prerequisites

## Technologies Used

- **Nextcloud** - A self-hosted productivity platform.  
    - Skills required - None to little
- **AWS** - Cloud platform used to host the infrastructure.
    - Skills required- Very little
- **Terraform** - Tool used to create the infrastructure.
    - Skills required - None to little
- **Ansible** - Tool used to modify the software within the infrastructure.
    - Skills required - Little to moderate

## Ensure AWS Creds Exist Locally

An existing AWS account is required.  Follow the instructions in this link to create an account - https://aws.amazon.com/premiumsupport/knowledge-center/create-and-activate-aws-account/.

Additionally, your AWS creds will need to configured locally.  Follow this link to get those setup - https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-files.html.

```bash
# Ensure AWS creds exist in `~/.aws/credentials`
$ cat ~/.aws/credentials
[default]
aws_access_key_id=djjgoijd
aws_secret_access_key=8dh3hgf8hfoih
```

# Configure Local Environment

## Clone This Repo

```bash
# Clone repo with SSH if GitHub account is configured with SSH keys
$ git clone git@github.com:jay-law/nextcloud-2-terraform.git

# or
# Clone repo with HTTPS
$ git clone https://github.com/jay-law/nextcloud-2-terraform.git

# cd into the repo directory
$ cd nextcloud-2-terraform/ 
```

## Generate Permission (.pem) File

1.  Log into AWS console
2.  Navigate to the EC2 service
3.  Left panel -> Under 'Nextwork & Security' -> Select 'Key Pairs'
4.  Select the orange 'Create key pair' button in the middle panel
5.  Enter 'nextcloud-2' for the name
6.  Select 'Create key pair'
7.  Download the pem file
    - This is the only time the pem file will be available to download.  If the pem file gets lost, delete then recreate the entry
8.  Save this file as it will be used in the next tutorial

## Install Terraform (Locally)

Terraform will be used to create the infrastructure used to host Nextcloud.

Guide - https://learn.hashicorp.com/tutorials/terraform/install-cli?in=terraform/aws-get-started

```bash
# Install required packages
$ sudo apt-get update && sudo apt-get install -y gnupg software-properties-common curl

# Add the HashiCorp GPG key
$ curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -

# Add the hashiCorp Linux repo
$ sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"

# Update repo
$ sudo apt-get update

# Install Terraform CLI
$ sudo apt-get install terraform

# Confirm Install
$ terraform -h

# These are not required but nice to have

# Ensure this file exists
$ touch ~/.bashrc

# Install the auto-complete package
$ terraform -install-autocomplete
```

# Build Infrastructure

Once the local machine is configured, Terraform is ready to build out the infrastructure.

```bash
# Initalize - downloads and installs the providers defined in the configuration
$ terraform init

# Format - automatically updates configurations in the current directory for readability and consistency
$ terraform fmt

# Validate - ensure configuration is syntactically valid and internally consistent
$ terraform validate

# Apply - apply the configuration
$ terraform apply
# enter 'yes' when prompted

# Terraform will now apply the changes specified in the main.tf and security_groups.tf files.  See comments in that file for block level information.
```

Everything should be up and running.  Log into the AWS console and see if the EC2 instance is in the 'Running' state.

# Next Steps

Continue the tutorial with this repo - https://github.com/jay-law/nextcloud-2-ansible

Or destroy the infrastructure so no additional costs are incurred.
```bash
$ terraform destroy
```