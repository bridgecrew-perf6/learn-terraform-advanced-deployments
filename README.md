# Learn Terraform Advanced Deployment Strategies

This demo is based on an official Terraform training demo.  The original readme file  read as follows:

git branches:
original -- used EC2 VMs for blue/green deployment
docker  -- deploy docker container; java app


│ Error: error creating ECS service (advanced-service): InvalidParameterException: The target group with targetGroupArn arn:aws:elasticloadbalancing:us-east-1:506504484053:targetgroup/java-app-deciding-firefly-lb-tg/edf1284d64e961e1 does not have an associated load balancer.
│
│   with aws_ecs_service.advanced-service,
│   on ecs.tf line 31, in resource "aws_ecs_service" "advanced-service":
│   31: resource "aws_ecs_service" "advanced-service" {
│
╵
╷
│ Error: error creating application Load Balancer: InvalidConfigurationRequest: Security group 'sg-00d098fbc4c653929' does not belong to VPC 'vpc-037b7c3c36eb4ab4f'
│ 	status code: 400, request id: 8f539602-3a95-47ea-8f77-2885c12da89c
│
│   with aws_lb.app,
│   on lb.tf line 2, in resource "aws_lb" "app":
│    2: resource "aws_lb" "app" {
│




Learn how to use Terraform and AWS's Application Load Balancers for canary tests and blue/green deployments. Learn how to add feature flags to your Terraform configuration by using variables and conditionals. Follow along with [this
tutorial](https://learn.hashicorp.com/tutorials/terraform/blue-green-canary-tests-deployments) on HashiCorp Learn.

Modifications to the official demo by John Kraus:

1.  We are deploying this infrastructure in AWS region 'us-east-1'.  Using the local region minimizes network latency.  Also, I was instructed by Felix Bravo to always use the 'us-east-1' region.
2. I changed the VPC CIDR avoid conflict with other infrastructure in the DevSecOps account.
3. I split some of the Terraform configuration into separate *.tf files.  This seems to be a common practice but is entirely optional and a matter of personal preference.  The number of *.tf files has no impact on the deployment.  Terraform treats separate *.tf files as if they were all concatenated into one big file. The load balancer configuration is moved from main.tf to lb.tf.  The VPC configuration is moved from main.tf to vpc.tf.
4.  I added default tags in the AWS provider block.  This ensures that (almost) every resource I create will have the tag Owner="John Kraus".  That way if I find an AWS resource tagged with me as the the owner, I feel pretty confident that I can destroy it without stepping on someone else's toes.  Also, other users of the AWS account will know who to blame for any of my messes.
5.  I upgraded my local Terraform executable and the Terraform version in version.tf to the current version: 1.1.4.  The important thing is for your local Terraform version to satisfy the version required in the Terraform block.
6.  I upgraded the AWS provider version to the most current version at the moment: 3.73.0.
7.  Upgraded the random provider to version 3.1.0.


for i in `seq 1 5`; do curl $(terraform output -raw lb_dns_name); done

for i in `seq 1 10`; do curl $(terraform output -raw lb_dns_name); done

terraform apply -var 'traffic_distribution=blue-90'

terraform apply -var 'traffic_distribution=green' -var 'enable_blue_env=false'

================

terraform apply

Start with prod environment: blue
Verify blue environment is receiving all requests:
- browse load balancer DNS name; and/or
- curl

for i in `seq 1 10`; do curl $(terraform output -raw lb_dns_name); done

Deploy green environment (aws_instance.green)

var.enable_green_env = true (default value)
var.green_instance_count = 2

for i in `seq 1 10`; do curl $(terraform output -raw lb_dns_name); done

Shift traffic to green environment
terraform apply -var 'traffic_distribution=blue-90'

for i in `seq 1 10`; do curl $(terraform output -raw lb_dns_name); done

Increase traffic to green environment

terraform apply -var 'traffic_distribution=split'

for i in `seq 1 10`; do curl $(terraform output -raw lb_dns_name); done

Promote green environment

terraform apply -var 'traffic_distribution=green'

for i in `seq 1 10`; do curl $(terraform output -raw lb_dns_name); done

Shift all traffic to green; disable blue env.

terraform apply -var 'traffic_distribution=green' -var 'enable_blue_env=false'

Alternating blue-green deployments. 
  Version 1.0 - Blue; 
  Version 1.1 - Green; 
  Version 1.2 - Blue; 
  Version 1.3 - Green...

Update blue app to version 1.2

Start shifting traffic to blue environment

terraform apply -var 'traffic_distribution=green-90'

for i in `seq 1 10`; do curl $(terraform output -raw lb_dns_name); done

terraform apply -var 'traffic_distribution=split'

for i in `seq 1 10`; do curl $(terraform output -raw lb_dns_name); done

terraform apply -var 'traffic_distribution=blue'

for i in `seq 1 10`; do curl $(terraform output -raw lb_dns_name); done


After verifying that the resources were deployed successfully, destroy them. Remember to respond to the confirmation prompt with yes.

terraform destroy -var 'traffic_distribution=blue'

## Convert to docker

aws ecr get-login-password --region us-east-1 --profile terraform-user-pgrm | docker login --username AWS --password-stdin 506504484053.dkr.ecr.us-east-1.amazonaws.com

docker build -t spring-boot .

OPTIONAL test for Docker image:

docker run -d -p 3000:3000 spring-boot
docker stop [container id]

Tag the image:

Tag name should be from 
resource "aws_ecr_repository" "advanced-ecr-repo" {
  name = "advanced-ecr-repo" 

docker tag spring-boot:1.0 506504484053.dkr.ecr.us-east-1.amazonaws.com/advanced-ecr-repo:latest

Push the image to AWS ECR:

docker push 506504484053.dkr.ecr.us-east-1.amazonaws.com/advanced-ecr-repo:latest

## After Updating your Java source code

JAVA_HOME=/Library/Java/JavaVirtualMachines/adoptopenjdk-12.jdk/Contents/Home

cd demo2

mvn clean package && docker build -t spring-boot-demo .

aws ecr get-login-password --region us-east-1 --profile terraform-user-pgrm | docker login --username AWS --password-stdin 506504484053.dkr.ecr.us-east-1.amazonaws.com

docker tag spring-boot-demo:latest 506504484053.dkr.ecr.us-east-1.amazonaws.com/advanced-ecr-repo:latest && docker push 506504484053.dkr.ecr.us-east-1.amazonaws.com/advanced-ecr-repo:latest

sonarqube container

docker tag sonarqube:8.6.9-developer 506504484053.dkr.ecr.us-east-1.amazonaws.com/sonarqube:8.9.6-developer

advanced-ecr-repo:latest

Push the image to AWS ECR:

docker push 506504484053.dkr.ecr.us-east-1.amazonaws.com/sonarqube:8.9.6-developer
