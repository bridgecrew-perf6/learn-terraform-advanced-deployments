# Learn Terraform Advanced Deployment Strategies

This demo is based on an official Terraform training demo.  The original readme file  read as follows:

git branches:
original -- used EC2 VMs for blue/green deployment
dockler  -- deploy docker container; java app




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

