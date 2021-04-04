# My Jenkins pipeline repo

Jenkins pipeline to run Terraform + Packer integration with AWS

## Prerequisites

### 1. An AWS account
If you do not have one yet, I recommend you go [here](https://aws.amazon.com/console/) and create one first, before you proceeding the following steps.

### 2. Install [Jenkins](https://jenkins.io/)
Follow the [Get Started](https://jenkins.io/doc/pipeline/tour/getting-started/) guide, and configure your jenkins server.

#### prerequisite installation for jenkins: [Java](https://www.oracle.com/technetwork/java/javase/downloads/index.html)
check that Java has successfully installed by command: `java -version`

### 3. install [Docker](https://docs.docker.com/)
verify by `docker -v`


## Set up

### Jenkins credentials
* AWS credentials (we mark this as "aws-credential" in the following doc). go to your Jenkins --> Credentials, create a new AWS credentials with your IAM key and secret.
** hint: If you do not have IAM yet, plz check this [link](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_create_for-user.html), and create one.
* Git credentials (we mark this as "git-credential" in the following doc). create a new git credential with your git username/password, or access-token

### Create Jenkins Pipeline
* Login your jenkins platform, create a new folder for the deployment by `New Item --> Folder`. You can provide any name for the folder as your own preference. 
* Navigate into the folder, create two pipelines items named: `Packer`, `Terraform` (This has to be the same as the folder names we use in this repo)

### Configurations

#### environments (not needed if you want to set up with Jenkins params)

* We are going to your local machine file system, or vm machine if this is what you working on, find the workspace of the Pipelines you just created. Usually it's under `~/.jenkins/workspace/<Your Folder Name>` (or you can find it in the "Home Directory" of `<Jenkins_url>/configure`). If there is nothing there, just create one with the same name (Jenkins will also automatically generate the folder when needed)
* Then under `~/.jenkins/workspace/<Your Folder Name>`, create a config file named `environments.config`, where you can find most values above:

**environments.config**
```
// The AWS configs
env.AWS_CREDENTIALS="<aws-credential>"
env.SOURCE_AMI_ID="<>"


// The Git configs
env.GIT_LINK="<The git url where you have your project, if don't have one yet you can use mine: "git@github.com:hotyhuang/testMyApp.git">"
env.GIT_CREDENTIALS="<git-credential>"

// Project related envs
env.PROJECT_NAME="<Any Name without Space!!>"
```

### [Packer setup](https://github.com/hotyhuang/cicd-jenkins/tree/Packer)

### [Terraform setup](https://github.com/hotyhuang/cicd-jenkins/tree/Terraform)

## Run the Deploy, Magic!!

Now it's ready to run the cicd. You just need to run "Packer", it will internally trigger the "Terraform" job.

---------------
## Known Issues

### 1.

If you see the error like `Scripts not permitted to use staticMethod...`, you will need to:
1. Navigate to jenkins > Manage jenkins > In-process Script Approval
2. There was a pending command, which I had to approve.

Issue Ref: https://stackoverflow.com/questions/38276341/jenkins-ci-pipeline-scripts-not-permitted-to-use-method-groovy-lang-groovyobject
