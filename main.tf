

module "vpc" {
  source = "./Networking/BasicNetworkingInfra"
  namespace = var.namespace
}