provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

resource "helm_release" "helm-consul-demo" {

  name = var.name

  repository = var.repository
  chart      = var.chart_name
  namespace  = var.namespace
}

locals {
  server_replicas       = var.server_replicas
  tls_enabled = false
}
