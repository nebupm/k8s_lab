module "iam" {
  source = "./modules/iam"
  name   = "k8s"
}

module "network" {
  source          = "./modules/network"
  aws_region      = var.aws_region
  aws_profile     = var.aws_profile
  environment     = var.environment
  vpc_name        = var.vpc_name
  vpc_cidr        = var.vpc_cidr
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
}

module "security" {
  source = "./modules/security"

  name            = "k8s"
  vpc_id          = module.network.vpc_id
  management_cidr = var.allowed_ssh_cidr
}
