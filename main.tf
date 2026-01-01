module "network" {
  source    = "./modules/network"
  app_name = var.app_name
  vpc_cidr = var.vpc_cidr
}

module "api_gateway" {
  source          = "./modules/api-gateway"
  app_name        = var.app_name
  vpc_id          = module.network.vpc_id
  private_subnets = module.network.private_subnets
  alb_listener_arn = module.alb.listener_arn
}

module "alb" {
  source          = "./modules/alb"
  app_name        = var.app_name
  vpc_id          = module.network.vpc_id
  private_subnets = module.network.private_subnets
  vpc_link_sg_id  = module.api_gateway.vpc_link_security_group_id
}

module "ecs" {
  source                = "./modules/ecs"
  app_name              = var.app_name
  vpc_id                = module.network.vpc_id
  private_subnets       = module.network.private_subnets
  alb_security_group_id = module.alb.alb_security_group_id
  target_group_arn      = module.alb.target_group_arn
  alb_listener_arn      = module.alb.listener_arn
}