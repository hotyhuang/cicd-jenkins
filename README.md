# Jenkins pipeline - Packer

## Prerequisites

Plz read [this](https://github.com/hotyhuang/cicd-jenkins#my-jenkins-pipeline-repo) b4 you come here


### Create Jenkins Pipeline job

In the Pipeline section, select "Pipeline script from SCM", and config the follow specs:
* Repository URL: git@github.com:hotyhuang/cicd-jenkins.git
* Credentials: <select the "git-credential" you created>
* Branch: `*/Packer`


### Configs
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

Otherwise, plz go to **Jenkins job(Packer) --> Configure --> update your params accordingly**
