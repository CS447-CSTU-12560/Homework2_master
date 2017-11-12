# CS447 (Operating System 2)
> Vedio Demo: https://youtu.be/LiiOx8zFlew
## Load balancer with auto Scaling by using Terraform
> - Go to directory you place terraform.tf file.<br />
> - Deploy this command.
```
terraform plan
```
> - When complete then.
```
terraform apply
```
> if you don't have terraform.<br />
> Go to: [Link](https://www.terraform.io/intro/getting-started/install.html)

## Locust for load test
> - Go to directory you place load.py file.<br />
> - Deploy this command and place your url.
```
locust -f load.py --host=${Your url}
```
> if you don't have locust.<br />
> install python and then.<br />
> Go to: [Link](https://docs.locust.io/en/latest/installation.html)
