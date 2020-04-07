## Description

This repo contains an example of using the aws ecs cli v2 tool to create a Python Flask application
and all of the infrastructure required to run it in a Fargate cluster.

When this successfully completes a URL will be output which can be used to access the ReST interface
for the application.

### Cost

A variety of resources will be created which are not free.

They include the following

* ALB - approximately $14 per month
* Fargate task that continuously runs - approximately $10 per month

To ensure that you are not billed after you have finished with this example do a *make delete* and ensure
that it completes successfully.

### What is needed to run this

* aws account with permissions to create various resources
* aws ecs cli v2 installed and configured, [https://github.com/aws/amazon-ecs-cli-v2](https://github.com/aws/amazon-ecs-cli-v2)
* the *jq* tool is used with the *make check* command to access the ReST url, [https://stedolan.github.io/jq/](https://stedolan.github.io/jq/)

### Usage

The normal usage of this would be as follows
* *make init* - create project metadata
* *make app* - create application metadata
* *make fix-manifest* - modify the manifest to match the app
* *make env* - create the aws resources
* *make deploy* - build, push and deploy the application to the cluster
* *make check* - get the application url and access it

If everything was successful you should see something like the following

```
$ make check
url is: http://flask-Publi-xxx-xxx.us-east-1.elb.amazonaws.com/api
Hello World!

```

* *make delete* - delete the resources that were created

### How this works

The ecs cli v2 uses CloudFormation to create AWS resources.
When this completes 4 new CloudFormation stacks will exist that will be named similarly to the following

* flask-test-flask
* StackSet-flask-infrastructure-xxx
* flask-test
* flask-infrastructure-roles

A CloudFormation stackset is also created

### Things to explore

After the deploy completes successfully there are various AWS resources to explore.

They include:

* Fargate cluster with service and task
* ECR repository
* CloudFormation stacks and stackset
* ALB
* target group

### Notes

* parameter store usage
  * ecs cli v2 uses the parameter store to save project and environment information
* cloudformation waits until stack action completed
* the app configuration files and source code must be in a git repository

