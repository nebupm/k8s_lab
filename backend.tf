# scripts/init-backend.sh will provide backend config during 'terraform init'.
# Instead of running terraform init directly, run the script.
# scripts/init-backend.sh has to be run from the k8s_lab directory.

terraform {
  backend "s3" {
    key     = "k8s/terraform.tfstate"
    encrypt = true
  }
}