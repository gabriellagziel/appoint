data "template_file" "api_availability" {
  template = file("${path.module}/api_availability.yaml.tmpl")
  vars = {
    namespace         = var.namespace
    api_uptime_target = var.api_availability_slo_percent
  }
}

resource "kubernetes_manifest" "api_availability" {
  manifest = yamldecode(data.template_file.api_availability.rendered)
}

data "template_file" "api_latency" {
  template = file("${path.module}/api_latency.yaml.tmpl")
  vars = {
    namespace            = var.namespace
    api_p95_latency_ms   = var.api_p95_latency_ms
    api_p99_latency_ms   = var.api_p99_latency_ms
  }
}

resource "kubernetes_manifest" "api_latency" {
  manifest = yamldecode(data.template_file.api_latency.rendered)
}

data "template_file" "booking_success" {
  template = file("${path.module}/booking_success.yaml.tmpl")
  vars = {
    namespace              = var.namespace
    booking_success_target = var.booking_success_slo_percent
  }
}

resource "kubernetes_manifest" "booking_success" {
  manifest = yamldecode(data.template_file.booking_success.rendered)
}
