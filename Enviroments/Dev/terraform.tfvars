# Resource Groups

rg_name = {
  rg1 = {
    name       = "dev_rg_01"
    location   = "West US 2"
    managed_by = "Terraform"
    tags = {
      project    = "tech-007"
      env        = "dev"
      team       = "dev-007"
      created_by = "Dinesh"
    }
  }

  rg2 = {
    name     = "dev_rg_02"
    location = "eastus"
  }
}

# Virtual Networks

vnet_name = {
  vnet1 = {
    name                           = "dev-vnet-01"
    location                       = "West US 2"
    resource_group_name            = "dev_rg_01"
    address_space                  = ["10.0.0.0/16"]
    bgp_community                  = "12076:20000"
    dns_servers                    = ["10.1.0.4", "10.1.0.5"]
    flow_timeout_in_minutes        = 10
    private_endpoint_vnet_policies = "Disabled"
    tags = {
      env = "dev"
    }
  }

  "vnet2" = {
    name                = "dev-vnet-02"
    location            = "West US 2"
    resource_group_name = "dev_rg_02"
    address_space       = ["10.2.0.0/16"]
  }
}

# Subnets

subnets = {
  subnet1 = {
    subnet_name                                   = "subnet-01"
    resource_group_name                           = "dev_rg_01"
    virtual_network_name                          = "dev-vnet-01"
    address_prefixes                              = ["10.0.1.0/24"]
    default_outbound_access_enabled               = true
    private_endpoint_network_policies             = "Disabled"
    private_link_service_network_policies_enabled = true
    service_endpoints                             = ["Microsoft.Storage", "Microsoft.Sql"]
  }

  subnet2 = {
    subnet_name                                   = "subnet-02"
    resource_group_name                           = "dev_rg_01"
    virtual_network_name                          = "dev-vnet-01"
    address_prefixes                              = ["10.0.2.0/24"]
    default_outbound_access_enabled               = false
    private_endpoint_network_policies             = "Disabled"
    private_link_service_network_policies_enabled = true
    service_endpoints                             = ["Microsoft.Storage"]
  }
  subnet3 = {
    subnet_name                                   = "subnet-03"
    resource_group_name                           = "dev_rg_01"
    virtual_network_name                          = "dev-vnet-01"
    address_prefixes                              = ["10.0.3.0/24"]
    default_outbound_access_enabled               = false
    private_endpoint_network_policies             = "Disabled"
    private_link_service_network_policies_enabled = true
    service_endpoints                             = ["Microsoft.Storage"]

    delegation = {
      name = "deleg-01"
      service_delegation = [
        {
          name    = "Microsoft.Web/serverFarms"
          actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
        }
      ]
    }
  }
  subnet4 = {
    subnet_name                                   = "AzureBastionSubnet"
    resource_group_name                           = "dev_rg_01"
    virtual_network_name                          = "dev-vnet-01"
    address_prefixes                              = ["10.0.4.0/24"]
    default_outbound_access_enabled               = false
    private_endpoint_network_policies             = "Disabled"
    private_link_service_network_policies_enabled = true
    service_endpoints                             = ["Microsoft.Storage"]
  }
}


# Public IP Addresses

public_ip = {
  "vm_pip" = {
    pip_name                = "dev-pip-01"
    resource_group_name     = "dev_rg_01"
    location                = "West US 2"
    allocation_method       = "Static"
    sku                     = "Standard"
    sku_tier                = "Regional"
    ddos_protection_mode    = "Enabled"
    domain_name_label       = "mywebapp"
    domain_name_label_scope = "NoReuse"
    idle_timeout_in_minutes = 4
    ip_version              = "IPv4"
    # tags = {
    #   env = "dev"
    # }
  }

  "bastion_pip" = {
    pip_name            = "dev-pip-03"
    resource_group_name = "dev_rg_01"
    location            = "West US 2"
    allocation_method   = "Static"
    tags = {
      env = "dev"
      app = "bastion"
    }
  }
}

# Network Security Groups

nsgs = {
  nsg1 = {
    nsg_name            = "devnsg01"
    location            = "West US 2"
    resource_group_name = "dev_rg_01"

    security_rule = [
      {
        name                       = "SSH_Rule"
        priority                   = 100
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        description                = "Allow ssh port"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
      },

      {
        name                         = "MultiPortsAndPrefixesRule1"
        priority                     = 200
        direction                    = "Inbound"
        access                       = "Allow"
        protocol                     = "Tcp"
        description                  = "Allow multiple ports from multiple prefixes"
        source_port_ranges           = ["1000-2000", "3000", "443"]
        destination_port_ranges      = ["80", "8080", "10000-10010"]
        source_address_prefixes      = ["10.0.0.0/24", "192.168.1.0/24"]
        destination_address_prefixes = ["0.0.0.0/0", ]
      },

      {
        name                         = "MultiPortsAndPrefixesRule2"
        priority                     = 300
        direction                    = "Outbound"
        access                       = "Allow"
        protocol                     = "Tcp"
        description                  = "Allow multiple ports to multiple prefixes"
        source_port_ranges           = ["1000-2000", "3000", "443"]
        destination_port_ranges      = ["80", "8080", "10000-10010"]
        source_address_prefixes      = ["10.0.1.0/24", "192.168.2.0/24"]
        destination_address_prefixes = ["0.0.0.0/0", ]
      }
    ]

    tags = {
      env = "dev"
    }
  }

  nsg2 = {
    nsg_name            = "devnsg02"
    location            = "West US 2"
    resource_group_name = "dev_rg_01"

    security_rule = [
      {
        name                       = "SSH_Rule"
        priority                   = 100
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        description                = "Allow ssh port"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
      },
    ]

    tags = {
      env = "dev"
    }
  }
}

# Subnets and NSGs Association

subnet_nsg_assoc = {
  sub_nsg_assoc1 = {
    nsg_name             = "devnsg01"
    virtual_network_name = "dev-vnet-01"
    subnet_name          = "subnet-01"
    resource_group_name  = "dev_rg_01"
  }

  sub_nsg_assoc2 = {
    nsg_name             = "devnsg01"
    virtual_network_name = "dev-vnet-01"
    subnet_name          = "subnet-02"
    resource_group_name  = "dev_rg_01"
  }
}

# Bastion Host

# bastion_hosts = {
#   bastion1 = {
#     bastion_host_name         = "dev-bastion-host"
#     resource_group_name       = "dev_rg_01"
#     location                  = "West US 2"
#     sku                       = "Standard"
#     virtual_network_name      = "dev-vnet-01"
#     subnet_name               = "AzureBastionSubnet"
#     pip_name                  = "dev-pip-03"
#     copy_paste_enabled        = true
#     file_copy_enabled         = true
#     ip_connect_enabled        = true
#     kerberos_enabled          = false
#     scale_units               = 3
#     shareable_link_enabled    = true
#     tunneling_enabled         = true
#     session_recording_enabled = false

#     ip_configuration = {
#       name = "bastion-ipconfig"
#     }

#     tags = {
#       environment = "dev"
#       project     = "bastion-dev"
#     }
#   }
# }

# Key Vault and Key Vault Secrets

key_vaults = {
  kv1 = {
    key_vault_name              = "dkcprodkv11"
    location                    = "West US 2"
    resource_group_name         = "dev_rg_01"
    enabled_for_disk_encryption = true
    soft_delete_retention_days  = 7
    purge_protection_enabled    = true
    sku_name                    = "standard"

    access_policy = {
      key_permissions     = ["Get", "Create"]
      secret_permissions  = ["Get", "List", "Set", "Delete", "Purge", "Recover"]
      storage_permissions = ["Get", "List", "Set"]
    }

    tags = {
      environment = "dev"
      owner       = "bhai"
    }
  }
}

key_vault_secrets = {
  vm_users = {
    secret_name         = "vm-username"
    secret_value        = "adminuser"
    key_vault_name      = "dkcprodkv11"
    resource_group_name = "dev_rg_01"
  }

  vm_pass = {
    secret_name         = "vm-password"
    secret_value        = "Bbpl@#123456"
    key_vault_name      = "dkcprodkv11"
    resource_group_name = "dev_rg_01"
  }

  sql_user = {
    secret_name         = "db-username"
    secret_value        = "dbuser"
    key_vault_name      = "dkcprodkv11"
    resource_group_name = "dev_rg_01"
  }

  sql_pass = {
    secret_name         = "db-password"
    secret_value        = "Bbpl@#123456"
    key_vault_name      = "dkcprodkv11"
    resource_group_name = "dev_rg_01"
  }

}

# Network Interface & VMs Configuration

vms = {
  "vm1" = {
    # NIC -    
    nic_name             = "dev-nic-01"
    location             = "West US 2"
    resource_group_name  = "dev_rg_01"
    subnet_name          = "subnet-01"
    virtual_network_name = "dev-vnet-01"
    # pip_name              = "dev-pip-01"
    # network_interface_ids = [""]
    ip_configuration = {
      ip_config_name                = "ipconfig1"
      private_ip_address_allocation = "Dynamic"
    }

    # VM -
    vm_name         = "app-vm-01"
    size            = "Standard_B1s"
    key_vault_name  = "dkcprodkv11"
    secret_name     = "vm-username"
    secret_password = "vm-password"

    os_disk = {
      caching              = "ReadWrite"
      storage_account_type = "Standard_LRS"
    }

    source_image_reference = {
      publisher = "Canonical"
      offer     = "0001-com-ubuntu-server-jammy"
      sku       = "22_04-lts"
      version   = "latest"
    }
    tags = {
      environment = "dev"
      owner       = "team-app"
    }
  }

#   "vm2" = {
#     # NIC -    
#     nic_name             = "dev-nic-02"
#     location             = "West US 2"
#     resource_group_name  = "dev_rg_01"
#     subnet_name          = "subnet-02"
#     virtual_network_name = "dev-vnet-01"
#     # pip_name             = "dev-pip-02"
#     # network_interface_ids = [""]
#     ip_configuration = {
#       ip_config_name                = "ipconfig1"
#       private_ip_address_allocation = "Dynamic"
#     }
#     # VM -
#     vm_name         = "db-vm-01"
#     size            = "Standard_B1s"
#     key_vault_name  = "dkcprodkv11"
#     secret_name     = "vm-username"
#     secret_password = "vm-password"
#     os_disk = {
#       caching              = "ReadWrite"
#       storage_account_type = "Standard_LRS"
#     }

#     source_image_reference = {
#       publisher = "Canonical"
#       offer     = "0001-com-ubuntu-server-jammy"
#       sku       = "22_04-lts"
#       version   = "latest"
#     }
#     tags = {
#       environment = "prod"
#       role        = "database"
#     }
#   }
}

# storage_accounts = {
#   "stg1" = {
#     name                     = "dkcstorageaccount01"
#     resource_group_name      = "dev_rg_01"
#     location                 = "West US 2"
#     account_tier             = "Standard"
#     account_replication_type = "LRS"
#     access_tier              = "Hot"
#   }
# }

# sql_servers = {
#   "server1" = {
#     name                          = "dkcsqlserver99"
#     resource_group_name           = "dev_rg_01"
#     location                      = "West US 2"
#     version                       = "12.0"
#     secret_name                   = "db-username"
#     secret_password               = "db-password"
#     key_vault_name                = "dkcprodkv11"
#     connection_policy             = "Default"
#     minimum_tls_version           = "1.2"
#     public_network_access_enabled = true
#     tags                          = { Environment = "Dev" }
#   }
# }

# sql_databases = {
#   "db1" = {
#     db_name             = "mydb1"
#     sql_server_name     = "dkcsqlserver99"
#     resource_group_name = "dev_rg_01"
#     sku_name            = "GP_Gen5_2"
#     max_size_gb         = 5
#     # min_capacity        = 0.5
#     short_term_retention_policy = {
#       retention_days = 7
#     }
#     threat_detection_policy = {
#       state                = "Enabled"
#       email_account_admins = "Enabled"
#       retention_days       = 30
#     }
#   }
# }



# load_balancers = {
#   dev-lb = {
#     # Load Balancer details
#     lb_name             = "dev-lb-01"
#     resource_group_name = "dev_rg_01"
#     location            = "West US 2"
#     sku                 = "Standard"
#     sku_tier            = "Regional"
#     tags = {
#       environment = "production"
#       owner       = "network-team"
#     }
#     # subnet_name = "subnet-02"
#     pip_name = "dev-pip-01"
#     # -------------------------------
#     # Frontend IP configuration
#     # -------------------------------
#     frontend_ip_configuration = {
#       fe1 = {
#         name = "frontend-1"
#         # zones                         = ["1", "2"]
#         # private_ip_address            = "10.0.1.10"
#         # private_ip_address_allocation = "Static"
#         # private_ip_address_version    = "IPv4"
#       }
#     }

#     # -------------------------------
#     # Backend Address Pool
#     # -------------------------------
#     ba_pool_name         = "backend-pool-1"
#     synchronous_mode     = "Automatic"
#     virtual_network_name = "dev-vnet-01"
#     # tunnel_interface = {
#     #   tun1 = {
#     #     identifier = "1001"
#     #     type       = "Internal"
#     #     protocol   = "VXLAN"
#     #     port       = 4789
#     #   }
#     # }

#     # -------------------------------
#     # LB Probe
#     # -------------------------------
#     lb_probes_name      = "http-health-probe"
#     port                = 80
#     probe_protocol      = "Http"
#     probe_threshold     = 3
#     request_path        = "/health"
#     interval_in_seconds = 10
#     number_of_probes    = 3

#     # -------------------------------
#     # LB Rule
#     # -------------------------------
#     lb_rules_name                  = "http-rule"
#     frontend_ip_configuration_name = "frontend-1"
#     lbrule_protocol                = "Tcp"
#     frontend_port                  = 80
#     backend_port                   = 80
#     floating_ip_enabled            = false
#     idle_timeout_in_minutes        = 5
#     load_distribution              = "Default"
#     disable_outbound_snat          = false
#     tcp_reset_enabled              = true
#   }
# }

# nic_ba_pool_assoc = {
#   nic_ba_pool_assoc1 = {
#     ip_configuration_name = "ipconfig1"
#     resource_group_name   = "dev_rg_01"
#     nic_name              = "dev-nic-01"
#     lb_name               = "dev-lb-01"
#     ba_pool_name          = "backend-pool-1"
#   }
#   nic_ba_pool_assoc2 = {
#     ip_configuration_name = "ipconfig1"
#     resource_group_name   = "dev_rg_01"
#     nic_name              = "dev-nic-02"
#     lb_name               = "dev-lb-01"
#     ba_pool_name          = "backend-pool-1"
#   }
# }





























