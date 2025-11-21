sleep 5
terraform init
terraform $* -var-file=.debug.tfvars -auto-approve