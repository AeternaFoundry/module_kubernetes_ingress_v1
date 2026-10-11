output "ingress_v1s_id" {
  description = "Map of id values across all ingress_v1s, keyed the same as var.ingress_v1s except keys with no id are omitted"
  value       = { for k, v in kubernetes_ingress_v1.ingress_v1s : k => v.id if v.id != null && length(v.id) > 0 }
}
output "ingress_v1s_metadata" {
  description = "Map of metadata values across all ingress_v1s, keyed the same as var.ingress_v1s except keys with no metadata are omitted"
  value       = { for k, v in kubernetes_ingress_v1.ingress_v1s : k => one(v.metadata) if v.metadata != null && length(v.metadata) > 0 }
}
output "ingress_v1s_spec" {
  description = "Map of spec values across all ingress_v1s, keyed the same as var.ingress_v1s except keys with no spec are omitted"
  value       = { for k, v in kubernetes_ingress_v1.ingress_v1s : k => one(v.spec) if v.spec != null && length(v.spec) > 0 }
}
output "ingress_v1s_status" {
  description = "Map of status values across all ingress_v1s, keyed the same as var.ingress_v1s except keys with no status are omitted"
  value       = { for k, v in kubernetes_ingress_v1.ingress_v1s : k => v.status if v.status != null && length(v.status) > 0 }
}
output "ingress_v1s_wait_for_load_balancer" {
  description = "Map of wait_for_load_balancer values across all ingress_v1s, keyed the same as var.ingress_v1s except keys with no wait_for_load_balancer are omitted"
  value       = { for k, v in kubernetes_ingress_v1.ingress_v1s : k => v.wait_for_load_balancer if v.wait_for_load_balancer != null }
}

