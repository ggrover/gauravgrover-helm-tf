variable "chart_name" {
  description = "Name of the Helm release"
  default = "consul"
}

variable "namespace" {
  description = "K8s namespace to use for chart install"
  default = "consul"
}

variable "server_replicas" {
  description = "The set of replica sets to have"
  default = 1
}

variable "repository" {
  description = "helm repository"
  default = "https://helm.releases.hashicorp.com"
}

variable "name" {
  description = "resource name"
  default = "helm-consul-demo"
}