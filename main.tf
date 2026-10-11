resource "kubernetes_ingress_v1" "ingress_v1s" {
  for_each = var.ingress_v1s

  wait_for_load_balancer = each.value.wait_for_load_balancer

  metadata {
    annotations   = each.value.metadata.annotations
    generate_name = each.value.metadata.generate_name
    labels        = each.value.metadata.labels
    name          = each.value.metadata.name
    namespace     = each.value.metadata.namespace
  }

  spec {
    dynamic "default_backend" {
      for_each = each.value.spec.default_backend != null ? [each.value.spec.default_backend] : []
      content {
        dynamic "resource" {
          for_each = default_backend.value.resource != null ? [default_backend.value.resource] : []
          content {
            api_group = resource.value.api_group
            kind      = resource.value.kind
            name      = resource.value.name
          }
        }
        dynamic "service" {
          for_each = default_backend.value.service != null ? [default_backend.value.service] : []
          content {
            name = service.value.name
            port {
              name   = service.value.port.name
              number = service.value.port.number
            }
          }
        }
      }
    }
    ingress_class_name = each.value.spec.ingress_class_name
    dynamic "rule" {
      for_each = each.value.spec.rule != null ? each.value.spec.rule : []
      content {
        host = rule.value.host
        dynamic "http" {
          for_each = rule.value.http != null ? [rule.value.http] : []
          content {
            dynamic "path" {
              for_each = http.value.path
              content {
                dynamic "backend" {
                  for_each = path.value.backend != null ? [path.value.backend] : []
                  content {
                    dynamic "resource" {
                      for_each = backend.value.resource != null ? [backend.value.resource] : []
                      content {
                        api_group = resource.value.api_group
                        kind      = resource.value.kind
                        name      = resource.value.name
                      }
                    }
                    dynamic "service" {
                      for_each = backend.value.service != null ? [backend.value.service] : []
                      content {
                        name = service.value.name
                        port {
                          name   = service.value.port.name
                          number = service.value.port.number
                        }
                      }
                    }
                  }
                }
                path      = path.value.path
                path_type = path.value.path_type
              }
            }
          }
        }
      }
    }
    dynamic "tls" {
      for_each = each.value.spec.tls != null ? each.value.spec.tls : []
      content {
        hosts       = tls.value.hosts
        secret_name = tls.value.secret_name
      }
    }
  }

  dynamic "timeouts" {
    for_each = each.value.timeouts != null ? [each.value.timeouts] : []
    content {
      create = timeouts.value.create
      delete = timeouts.value.delete
    }
  }
}

