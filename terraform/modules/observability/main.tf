locals {
  metrics_retention_str = format("%dd", var.metrics_retention_days)
  trace_retention_str   = format("%dd", var.trace_retention_days)
}

resource "helm_release" "kube_prometheus_stack" {
  name       = "kube-prometheus-stack"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  namespace  = var.namespace

  values = [
    yamlencode({
      prometheus = {
        prometheusSpec = {
          retention = local.metrics_retention_str
        }
      }
    })
  ]
}

resource "helm_release" "tempo" {
  name       = "tempo"
  repository = "https://grafana.github.io/helm-charts"
  chart      = "tempo"
  namespace  = var.namespace

  values = [
    yamlencode({
      retention = {
        time = local.trace_retention_str
      }
    })
  ]
}
