module "conventions-redis" {
  for_each     = toset(var.locations)
  source       = "<special module to handle naming conventions>"
  resource     = "redis"
  environment  = var.environment
  location     = each.key
  servicegroup = var.servicegroup
  ownerEmail   = var.ownerEmail
  id           = var.id
  pod          = var.pod
  stenantid    = var.stenantid
}

resource "random_string" "randomName" {
  length  = 8
  special = false
  upper   = false
}

resource "azurerm_redis_enterprise_cluster" "cluster" {
  for_each            = toset(var.locations)
  name                = join("-", [local.resource_prefix, var.useRandomNamePart ? "${local.service_name}-${random_string.randomName.result}" : local.service_name, each.key, var.environment])
  resource_group_name = module.conventions-redis[each.key].resource_group_name
  location            = each.key 

  sku_name            = var.sku
  minimum_tls_version = "1.2"
  tags                = module.conventions-redis[each.key].service_tags

  zones = length(var.zones) > 0 ? var.zones : null

  lifecycle {
      ignore_changes = [
      name,
      zones
      ]
}
}

resource "azurerm_redis_enterprise_database" "db" {
  name              = "default"
  cluster_id        = azurerm_redis_enterprise_cluster.cluster["${var.locations[0]}"].id
  clustering_policy = var.clustering_policy
  client_protocol   = var.client_protocol
  eviction_policy   = var.eviction_policy
  port              = var.port

  linked_database_id = [for c in azurerm_redis_enterprise_cluster.cluster : "${c.id}/databases/default"]

  linked_database_group_nickname = var.linked_database_group_nickname
  lifecycle {
    ignore_changes = [
      name
    ]
  }
}


terraform {
  required_version = ">= 0.14.11"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.9.0"
    }
  }
}
