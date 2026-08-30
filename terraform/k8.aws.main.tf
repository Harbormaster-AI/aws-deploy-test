
# Modules
module "eks" {
  source   = "./eks"
  aws_access_key = var.aws_access_key
  aws_secret_key = var.aws_secret_key
  region         = var.region
}

module "k8s" {
  source   = "./k8s"
}

provider "kubernetes" {
    host = module.eks.eks_cluster_endpoint
    cluster_ca_certificate = base64decode(
      module.eks.certificate_authority_data
    )

    exec {
      api_version = "client.authentication.k8s.io/v1"

      command = "aws"

      args = [
        "eks",
        "get-token",
        "--cluster-name",
        module.eks.cluster_name
      ]
    }
}