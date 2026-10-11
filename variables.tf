variable "ingress_v1s" {
  description = <<EOT
Map of ingress_v1s, attributes below
Required:
    - metadata (block):
        - annotations (optional)
        - generate_name (optional)
        - labels (optional)
        - name (optional)
        - namespace (optional)
    - spec (block):
        - default_backend (optional, block):
            - resource (optional, block):
                - api_group (required)
                - kind (required)
                - name (required)
            - service (optional, block):
                - name (required)
                - port (required, block):
                    - name (optional)
                    - number (optional)
        - ingress_class_name (optional)
        - rule (optional, block):
            - host (optional)
            - http (optional, block):
                - path (required, block):
                    - backend (optional, block):
                        - resource (optional, block):
                            - api_group (required)
                            - kind (required)
                            - name (required)
                        - service (optional, block):
                            - name (required)
                            - port (required, block):
                                - name (optional)
                                - number (optional)
                    - path (optional)
                    - path_type (optional)
        - tls (optional, block):
            - hosts (optional)
            - secret_name (optional)
Optional:
    - wait_for_load_balancer
    - timeouts (block):
        - create (optional)
        - delete (optional)
EOT

  type = map(object({
    wait_for_load_balancer = optional(bool)
    metadata = object({
      annotations   = optional(map(string))
      generate_name = optional(string)
      labels        = optional(map(string))
      name          = optional(string)
      namespace     = optional(string)
    })
    spec = object({
      default_backend = optional(object({
        resource = optional(object({
          api_group = string
          kind      = string
          name      = string
        }))
        service = optional(object({
          name = string
          port = object({
            name   = optional(string)
            number = optional(number)
          })
        }))
      }))
      ingress_class_name = optional(string)
      rule = optional(list(object({
        host = optional(string)
        http = optional(object({
          path = list(object({
            backend = optional(object({
              resource = optional(object({
                api_group = string
                kind      = string
                name      = string
              }))
              service = optional(object({
                name = string
                port = object({
                  name   = optional(string)
                  number = optional(number)
                })
              }))
            }))
            path      = optional(string)
            path_type = optional(string)
          }))
        }))
      })))
      tls = optional(list(object({
        hosts       = optional(list(string))
        secret_name = optional(string)
      })))
    })
    timeouts = optional(object({
      create = optional(string)
      delete = optional(string)
    }))
  }))
  validation {
    condition = alltrue([
      for k, v in var.ingress_v1s : (
        v.spec.rule == null || alltrue([for item in v.spec.rule : (item.http == null || (length(item.http.path) >= 1))])
      )
    ])
    error_message = "Each path list must contain at least 1 items"
  }
}

