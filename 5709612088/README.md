# OS2_HW2
  
> - DEMO @https://youtu.be/uPj_6IRhBSY
  
## Create load balancer with auto scaling
> Simple web app with high cpu usage
  
## Features
> 1. create load balancer  
> 2. scale up's policy  
> 3. scale down's policy  
  
## Prerequisite  
> 1. RSA key (e.g. using puttykeygen)  
> 2. AWS access and secret key  
> 3. locust  
> 4. terraform  
  
## Create RSA KEY
>  follow this instruction @https://docs.joyent.com/public-cloud/getting-started/ssh-keys/generating-an-ssh-key-manually/manually-generating-your-ssh-key-in-windows
  
## Create AWS acress and secret key
>  follow this instruction @http://docs.aws.amazon.com/general/latest/gr/managing-aws-access-keys.html
  
## Installing Locust
>  Must have python pip
```
pip install locustio
```
  
## Installing terraform
> follow this instruction @https://www.terraform.io/intro/getting-started/install.html
  
## How to
> 1. check everything in terra.tf  
> 2. if you don't want to use Target group ARN use terra in TerraformWithLoadBalancer  
> 3. else you have to create own load balancer with target group  
> 4. use command "terraform plan" in terminal or CMD  
> 5. use command "terraform apply" in terminal or CMD  
> 6. if you want to test auto scaling use locust with command "locust --host=${web url}"  
  
  
Operation System 2 Homework2  
created by TheTonG
