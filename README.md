# Camply runner
[Camply](https://github.com/juftin/camply) is a tool that checks national park campsites for their availability.

In order to run it, you need to have a computer that's always on that will continually pull for you.

Here is some terraform code that will create an EC2 instance, install camply, and automatically search for you.

To run:
1. Update environment variables in terraform/main.tf
2. Run the following:
```
terraform init
terraform apply
```

Or, if you've been around the block a few times:
```
terraform destroy -auto-approve && terraform apply -auto-approve
# for debugging the server: 
ssh -i "my_key.pem" ubuntu@<IP FROM ABOVE>
# On remote machine: 
less -N /var/log/cloud-init-output.log
```
