# Jenkins pipeline - Packer

## Prerequisites

Plz read [this](https://github.com/hotyhuang/cicd-jenkins#my-jenkins-pipeline-repo) b4 you come here

### Create Jenkins Pipeline job, named "Terraform", under same folder as - Packer

In the Pipeline section, select "Pipeline script from SCM", and config the follow specs:
* Repository URL: git@github.com:hotyhuang/cicd-jenkins.git
* Credentials: <select the "git-credential" you created>
* Branch: `*/Terraform`

## Configs

### environment vars

If you choose to set up with **environments.config**, there is nothing you need to do here.

sample **environments.config**:
```
// The AWS configs
env.AWS_CREDENTIALS="<aws-credential>"
env.SOURCE_AMI_ID="<your source ami id>"


// The Git configs
env.GIT_LINK="<
The git url where you have your project, if don't have one yet you can use mine: "git@github.com:hotyhuang/testMyApp.git"
>"
env.GIT_CREDENTIALS="<git-credential>"

// Project related envs
env.PROJECT_NAME="<Any Name without Space!!>"
```

Otherwise, plz go to **Jenkins job(Terraform) --> Configure --> update your params accordingly**

### Terraform variables

Go to [variable.tf](variable.tf), add the required fields with your own aws details.

**Terraform/variable.tf**
```
# These are empty defined vars, just to pass from jenkins deploy
variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "region" {}
variable "env" {}
variable "project_name" {}
variable "new_instance_type" {}

# The below vars are required
variable "security_group_ids" {
  default = "xxx"
}

variable "vpc_id" {
  default = "xxx"
}

variable "subnet_id" {
  default = "xxx"
}

variable "subnet_id2" {
  default = "xxx"
}

variable "aws_account_num" {
  default = "xxx"
}

variable "key_pair_name" {
  default = "xxx"
}

variable "r53_zone_id" {
  default = "xxx"
}

variable "r53_domain_name" {
  default = "xxx"
}
```

