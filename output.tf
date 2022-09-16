output "redis" {
  value = azurerm_redis_enterprise_cluster.cluster
}
output "redis_ids" {
  value = [for location in var.locations :
      azurerm_redis_enterprise_cluster.cluster[location].id
  ]
}
output "hostnames" {
  value = [for location in var.locations :
      azurerm_redis_enterprise_cluster.cluster[location].hostname
  ]
}
output "primary_access_key" {
  value     = azurerm_redis_enterprise_database.db.primary_access_key
  sensitive = true
}
output "secondary_access_key" {
  value     = azurerm_redis_enterprise_database.db.secondary_access_key
  sensitive = true
}
