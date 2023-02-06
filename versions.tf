terraform {
  required_version = ">= 0.13"

  required_providers {
    helm = {
      source = "hashicorp/helm"
      version = "2.8.0"
    }
  }
  
  backend "s3" {
    region = "us-west-2"
    bucket = "cdktf-backend-k8s"
    key = "helm-consul-demo"
    encrypt = true
  }
}
