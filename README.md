# My Jenkins pipeline repo

Jenkins pipeline to run Terraform + Packer integration with AWS

## Prerequisites

### 1. An AWS account
If you do not have one yet, I recommend you go [here](https://aws.amazon.com/console/) and create one first, before you proceeding the following steps.

### 2. Install [Jenkins](https://jenkins.io/)
Follow the [Get Started](https://jenkins.io/doc/pipeline/tour/getting-started/) guide, and configure your jenkins server.

### 3. install [Java](https://www.oracle.com/technetwork/java/javase/downloads/index.html)
check that Java has successfully installed by command: `java -version`

### 4. install [Docker](https://docs.docker.com/)
verify by `docker -v`

### 5. install [Packer](https://www.packer.io/downloads.html)
verify by `packer -v`

### 6. install [Terraform](https://www.terraform.io/downloads.html)
verify by `terraform -v`

### 7. install [aws-cli](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv1.html)
I only installed with version 1. If you have tried with version 2, let me know how it goes...

## Set up

### Jenkins credentials
* AWS credentials (we mark this as "aws-credential" in the following doc). go to your Jenkins --> Credentials, create a new AWS credentials with your IAM key and secret.
** hint: If you do not have IAM yet, plz check this [link](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_create_for-user.html), and create one.
* Git credentials (we mark this as "git-credential" in the following doc). create a new git credential with your git username/password, or access-token

### Create Jenkins Pipeline
* Login your jenkins platform, create a new folder for the deployment by `New Item --> Folder`. You can provide any name for the folder as your own preference. 
* Navigate into the folder, create two pipelines items named: `Packer`, `Terraform` (This has to be the same as the folder names we use in this repo)

### Manage Configs
* Now we are going to your local machine file system, or vm machine if this is what you working on, find the workspace of the Pipelines you just created. Usually it's under `~/.jenkins/workspace/<Your Folder Name>` (or you can find it in the "Home Directory" of `<Jenkins_url>/configure`). If there is nothing there, just create one with the same name (Jenkins will also automatically generate the folder when needed)
* Then under `~/.jenkins/workspace/<Your Folder Name>`, create a config file named `environments.config`, where you can find most values above:

**environments.config**
```
// The AWS configs
env.AWS_CREDENTIALS=<aws-credential>
env.SOURCE_AMI_ID=<>


// The Git configs
env.GIT_LINK=<The git url where you have your project, if don't have one yet you can use mine: "git@github.com:hotyhuang/testMyApp.git">
env.GIT_CREDENTIALS=<git-credential>

// Project related envs
env.PROJECT_NAME=<Any Name without Space!!>
```

* Then make Terraform folder by `mkdir Terraform`. And create a `variable.tf` file with your aws details. This will be used to run Terraform:

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

So your final folder structure will look like this:

```
--workspace
 |--MyFolder
    |--Packer
       |...
    |--Terraform
      |--variable.tf
      |--....
    |--environments.config
    |--...
```

## Run the Deploy, Magic!!

Now it's ready to run the cicd. You just need to run "Packer", it will internally trigger the "Terraform" job.

---------------
## Known Issues

### 1.

If you see the error like `Scripts not permitted to use staticMethod...`, you will need to:
1. Navigate to jenkins > Manage jenkins > In-process Script Approval
2. There was a pending command, which I had to approve.

Issue Ref: https://stackoverflow.com/questions/38276341/jenkins-ci-pipeline-scripts-not-permitted-to-use-method-groovy-lang-groovyobject
