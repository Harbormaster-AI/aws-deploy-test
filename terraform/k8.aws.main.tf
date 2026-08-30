
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
    host = aws_eks_cluster.this.endpoint
    cluster_ca_certificate = base64decode(
     aws_eks_cluster.this.certificate_authority_data
    )

    exec {
      api_version = "client.authentication.k8s.io/v1"

      command = "aws"

      args = [
        "eks",
        "get-token",
        "--cluster-name",
        aws_eks_cluster.this.name
      ]
    }
}