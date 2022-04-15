

module "vpc" {
  source    = "./Networking/BasicNetworkingInfra"
  namespace = var.namespace
}

module "container" {
  source    = "./containers"
  repo-name = var.repo-name
  namespace = var.namespace
  sg        = module.vpc.sg
  vpc       = module.vpc.vpc

}