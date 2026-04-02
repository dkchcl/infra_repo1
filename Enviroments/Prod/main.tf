module "rg" {
  source  = "../../Modules/azurerm_resource_group"
  rg_name = var.rg_name
}

module "vnet" {
  depends_on = [module.rg]
  source     = "../../Modules/azurerm_virtual_network"
  vnet_name  = var.vnet_name
}

module "subnet" {
  depends_on = [module.vnet]
  source     = "../../Modules/azurerm_subnet"
  subnets    = var.subnets
}

module "public_ip" {
  depends_on = [module.rg]
  source     = "../../Modules/azurerm_public_ip"
  public_ip  = var.public_ip
}

module "nsg" {
  depends_on = [module.rg]
  source     = "../../Modules/azurerm_network_security_group"
  nsgs       = var.nsgs
}

module "subnet_nsg_nic_assoc" {
  depends_on       = [module.nsg, module.subnet]
  source           = "../../Modules/azurerm_subnet_nsg_nic_assoc"
  subnet_nsg_assoc = var.subnet_nsg_assoc

}

# Bastion Host

# module "bastion_host" {
#   depends_on    = [module.public_ip, module.subnet, ]
#   source        = "../../Modules/azurerm_bastion_host"
#   bastion_hosts = var.bastion_hosts
# }

module "kv" {
  depends_on = [module.rg]
  source     = "../../Modules/azurerm_key_vault"
  key_vaults = var.key_vaults
}

module "kvs" {
  depends_on        = [module.kv]
  source            = "../../Modules/azurerm_key_vault_secret"
  key_vault_secrets = var.key_vault_secrets
}


module "vm" {
  depends_on = [module.rg, module.vnet, module.subnet, module.public_ip, module.nsg, module.kv, module.kvs]
  source     = "../../Modules/azurerm_virtual_machine"
  vms        = var.vms
}

module "stg" {
  depends_on       = [module.rg]
  source           = "../../Modules/azurerm_storage_account"
  storage_accounts = var.storage_accounts
}

module "sql_server" {
  depends_on  = [module.rg]
  source      = "../../Modules/azurerm_sql_server"
  sql_servers = var.sql_servers
}

module "sql_db" {
  depends_on    = [module.sql_server]
  source        = "../../Modules/azurerm_sql_database"
  sql_databases = var.sql_databases
}





