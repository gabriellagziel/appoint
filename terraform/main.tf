terraform {
  required_version = ">= 1.3"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.20"
    }
    kubernetes-alpha = {
      source  = "hashicorp/kubernetes-alpha"
      version = ">= 0.7"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.13"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

provider "kubernetes" {
  config_path = var.kubeconfig_path
}

provider "kubernetes-alpha" {
  config_path = var.kubeconfig_path
}

provider "helm" {
  kubernetes {
    config_path = var.kubeconfig_path
  }
}

module "observability" {
  source                = "./modules/observability"
  namespace             = var.monitoring_namespace
  metrics_retention_days = var.metrics_retention_days
  trace_retention_days   = var.trace_retention_days
}

module "log_bucket" {
  source            = "./modules/log_bucket"
  bucket_name       = var.log_bucket_name
  log_retention_days = var.log_retention_days
}

module "alerts" {
  source                 = "./modules/alerts"
  namespace              = var.monitoring_namespace
  api_uptime_target      = var.api_uptime_target
  api_p95_latency_ms     = var.api_p95_latency_ms
  api_p99_latency_ms     = var.api_p99_latency_ms
  booking_success_target = var.booking_success_target
}
