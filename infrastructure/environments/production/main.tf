module "vpc" {
    source = "../../modules/network"

    environment = "production"
    cidr_block = "192.168.0.0/16"
    public = true

}

module "cluster" {
    source = "../../modules/ecs/cluster"
    name = "production-cluster"
    environment = "production"
    size = 5
    subnet_ids = module.vpc.subnet_ids
    vpc_id = module.vpc.id
}

module "hello-service" {
    source = "../../modules/ecs/service"
    subnet_ids = module.vpc.subnet_ids
    vpc_id = module.vpc.id
    environment = "production"
    image = "pleymo/greeting-service"
    health_check_path = "/greet"
    service_name = "hello"
    port = 8080
    cluster_id = module.cluster.id
    # size = 3 #Add size
}

output "url" {
    value = module.hello-service.lb_dns
}