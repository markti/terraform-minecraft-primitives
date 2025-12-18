terraform init
terraform destroy -var-file=.debug.tfvars -auto-approve
terraform apply -var-file=.debug.tfvars -auto-approve