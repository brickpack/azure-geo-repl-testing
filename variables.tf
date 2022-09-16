
# Redis parameters
variable "locations" {
  type        = list
  default     = ["eastus2","westus2"]
  description = "(Optional) List of regions for Active Geo-Replication"
}
variable "linked_database_id" {
  type        = set(string)
  default     = []
  description = "(Optional) A list of database resources to link with this database with a maximum of 5."
}
variable "linked_database_group_nickname" {
  type        = string
  default     = "redis-geo-group"
  description = "(Optional) Nickname of the group of linked databases. Changing this force a new Redis Enterprise Geo Database to be created."
}
variable "cluster_name_prefix" {
  type        = string
  description = "Prefix to use for the Azure Cache for Redis Enterprise cluster. Will be suffixed by the region name."
}


variable "sku" {
  default     = "Enterprise_E10-2"
  description = "https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/redis_enterprise_cluster#sku_name - e.g. Enterprise_E10-2"
}
## This should be enabled when the module supports an actual name
# variable db_name {
#   description = "The name which should be used for this Redis Enterprise Database. Changing this forces a new Redis Enterprise Database to be created."
#   type        = string
#   default     = "default" # As of now, "default" is the only value that's accepted
# }

variable "cluster_id" {
  description = "* Changing this forces a new Redis Enterprise Database to be created. The resource id of the Redis Enterprise Cluster to deploy this Redis Enterprise Database."
  type        = string
  default     = ""
}
variable "zones" {
  type        = list(string)
  default     = [1, 2, 3]
  description = "List of Availability Zones to deploy to. e.g. [1, 2, 3]"
}

variable "clustering_policy" {
  type        = string
  default     = "EnterpriseCluster"
  description = "* Changing this forces a new Redis Enterprise Database to be created. Clustering policy - default is OSSCluster. Specified at create time. Possible values are EnterpriseCluster and OSSCluster. Defaults to OSSCluster."
}
variable "client_protocol" {
  type        = string
  default     = "Encrypted"
  description = "* Changing this forces a new Redis Enterprise Database to be created. Specifies whether redis clients can connect using TLS-encrypted or plaintext redis protocols. Default is TLS-encrypted. Possible values are Encrypted and Plaintext. Defaults to Encrypted."
}
variable "eviction_policy" {
  type        = string
  default     = "VolatileLRU"
  description = "* Changing this forces a new Redis Enterprise Database to be created. Redis eviction policy - default is VolatileLRU. Possible values are AllKeysLFU, AllKeysLRU, AllKeysRandom, VolatileLRU, VolatileLFU, VolatileTTL, VolatileRandom and NoEviction. Defaults to VolatileLRU."
}
variable "port" {
  type        = number
  default     = 10000
  description = "* Changing this forces a new Redis Enterprise Database to be created. TCP port of the database endpoint. Specified at create time. Defaults to an available port."
}

# Common params
variable "environment" {}
variable "servicegroup" {}
variable "ownerEmail" {}
variable "stenantid" { default = "" }
variable "utenantid" { default = "" }
variable "pod" { default = "" }
variable "id" {
  type        = number
  default     = 1
  description = "Changes the name of the instance. This is unsual to change from deafult"
}

variable "useRandomNamePart" {
  type        = bool
  default     = false
  description = "(Optional) Add random string to name of redis server."
}

locals {
  service_name = join("-", flatten([
    var.servicegroup,
    var.pod != "" ? [var.pod] : [],
    var.stenantid != "" ? [var.stenantid] : []
  ]))
  resource_prefix = format("%s%02d", "redis", min(99, max(1, var.id)))
}
