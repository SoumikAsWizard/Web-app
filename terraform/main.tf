terraform {
  required_version = ">= 1.5.0"
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.31"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.13"
    }
  }
}

provider "kubernetes" {
  config_path = var.kubeconfig_path
}

provider "helm" {
  kubernetes {
    config_path = var.kubeconfig_path
  }
}

variable "kubeconfig_path" {
  description = "Path to your kubeconfig (e.g., ~/.kube/config)"
  type        = string
  default     = "~/.kube/config"
}

variable "image_repository" {
  description = "Container image repo"
  type        = string
  default     = "ghcr.io/your-org/securecloudshop"
}

variable "image_tag" {
  description = "Container image tag"
  type        = string
  default     = "latest"
}

resource "helm_release" "securecloudshop" {
  name         = "securecloudshop"
  chart        = "../helm/securecloudshop"
  force_update = true

  set {
    name  = "image.repository"
    value = var.image_repository
  }
  set {
    name  = "image.tag"
    value = var.image_tag
  }
}
