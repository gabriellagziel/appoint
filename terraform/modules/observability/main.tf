
resource "helm_release" "kube_prometheus_stack" {
  name       = "kube-prometheus-stack"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  namespace  = var.namespace

  values = [
    yamlencode({
      prometheus = {
        prometheusSpec = {
          retention = var.metrics_retention_period
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
        time = var.trace_retention_period
      }
    })
  ]
}
