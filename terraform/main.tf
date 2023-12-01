provider "aws" {
  region = var.region
}

terraform {
  backend "s3" {
    bucket = "servicelens-demo"
    key    = "us-east-1/servicelens-demo"
    region = "us-east-1"
  }
}

module "vpc" {
  source      = "./modules/vpc"
}

module "subnet" {
  source      = "./modules/subnet"
  aws_vpc = module.vpc.aws_vpc_output
}

module "iam" {
  source      = "./modules/iam"
}

module "ecr" {
  source      = "./modules/ecr"
}

module "security-group" {
  source      = "./modules/security-group"
  aws_vpc = module.vpc.aws_vpc_output
}


module "ecs" {
  source      = "./modules/ecs"
  ecr_repository_url = module.ecr.ecr_repository_url
  iam_role_arn = module.iam.node-iam-arn
  csharp_subnet_1 = module.subnet.csharp_subnet_1
  csharp_subnet_2 = module.subnet.csharp_subnet_2
  security_group_id = module.security-group.security_group_id
}

module "internet-gateway" {
  source      = "./modules/internet-gateway"
  aws_vpc = module.vpc.aws_vpc_output
  csharp_subnet_1 = module.subnet.csharp_subnet_1
  csharp_subnet_2 = module.subnet.csharp_subnet_2
}




