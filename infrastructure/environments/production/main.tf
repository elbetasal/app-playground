module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "production-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["us-east-1a", "us-east-1b", "us-east-1c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway     = true
  single_nat_gateway     = true
  one_nat_gateway_per_az = true

  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Terraform   = "true"
    Environment = "prod"
    Org         = "elbeta"
  }

}

module "cluster" {
  source       = "../../modules/ecs/cluster"
  cluster_name = "production-cluster"
  environment  = "production"
  size         = 2
  subnet_ids   = module.vpc.private_subnets
  vpc_id       = module.vpc.vpc_id
}
module "lb" {
  source      = "../../modules/alb"
  environment = "production"
  subnet_ids  = module.vpc.public_subnets
  vpc_id      = module.vpc.vpc_id

}
#
#
module "hello-service" {
  source            = "../../modules/ecs/service"
  environment       = "production"
  image             = "pleymo/greeting-service"
  health_check_path = "/"
  service_name      = "hello"
  port              = 8080
  cluster_id        = module.cluster.id
  desired_size      = 2
  lb_arn            = module.lb.listener_arn
  entrypoint        = "hello.production.elbeta.dev"
  vpc_id            = module.vpc.vpc_id
  service_registry_id = module.cluster.service_discovery_registry_id
  service_registry_arn = module.cluster.service_discovery_registry_arn
  private_subnets = module.vpc.private_subnets
}

//module "book-service" {
//    source = "../../modules/ecs/service"
//    subnet_ids = module.vpc.subnet_ids
//    vpc_id = module.vpc.id
//    environment = "production"
//    image = "pleymo/book-service"
//    health_check_path = "/"
//    service_name = "book"
//    port = 8080
//    cluster_id = module.cluster.id
//    desired_size = 2
//    entrypoint = "/booking/*"
//    lb_arn = module.lb.listener_arn
//}
