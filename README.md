# My Jenkins pipeline repo

Jenkins pipeline to run Terraform + Packer integration with AWS

## Prerequisites

* install [Java](https://www.oracle.com/technetwork/java/javase/downloads/index.html), verify by `java -version`
* install [Jenkins](https://jenkins.io/), put in a location where you can easily access
* install [Docker](https://docs.docker.com/), verify by `docker -v`
* install [Packer](https://www.packer.io/downloads.html), verify by `packer -v`
* install [Terraform](https://www.terraform.io/downloads.html), verify by `terraform -v`

## Run Jenkins

After you installed all the prerequisites, navigate to the folder where you put your `jenkins.war`, and run the command:

```
java -jar jenkins.war
```

You may need to walk through some settings if it is the first time running jenkins on the machine. You can find some instructions [here](https://jenkins.io/doc/pipeline/tour/getting-started/)

## Get Ready

* In your jenkins platform, "New Item --> Pipeline". Or if you want to better orgnize your jobs, "New Item --> Folder", then "New Item --> Pipeline"
* create the pipelines named: `Packer`, `Terraform`
* navigate to this location (normally in `~/.jenkins/workspace` for mac, or you can run a job with `pwd` command), do a `git clone https://github.com/hotyhuang/cicd-jenkins.git`
* create a config file named `environments.config`, with the following sample:
```
// The AWS configs
env.AWS_CREDENTIALS="aws-admin"
env.SOURCE_AMI_ID="ami-0c2d60a4500b9501e"


// The Git configs
env.GIT_LINK="git@github.com:hotyhuang/testMyApp.git"
env.GIT_CREDENTIALS="personal-git"

// Project related envs
env.PROJECT_NAME="Test App"
```

Unfortunately, you have to config the credentials (git & aws) yourself in your "Credentials" tab. Then, fill up the common configs in the `environments.config` file. You may also modify the params when running the job.

## Run the Deploy

Now it's ready to run your deployment. Usually you just need to run "Terraform", it will internally trigger the "Packer" job.

---------------
## Known Issues

### 1.

If you see the error like `Scripts not permitted to use staticMethod...`, you will need to:
1. Navigate to jenkins > Manage jenkins > In-process Script Approval
2. There was a pending command, which I had to approve.

Issue Ref: https://stackoverflow.com/questions/38276341/jenkins-ci-pipeline-scripts-not-permitted-to-use-method-groovy-lang-groovyobject
