# Resource Groups

rg_name = {
  rg1 = {
    name       = "preprod_rg_01"
    location   = "westus"
    managed_by = "Terraform"
    tags = {
      project    = "tech-007"
      env        = "preprod"
      team       = "preprod-007"
      created_by = "Dinesh"
    }
  }

  rg2 = {
    name     = "preprod_rg_02"
    location = "eastus"
  }
}

# Virtual Networks

vnet_name = {
  vnet1 = {
    name                           = "preprod-vnet-01"
    location                       = "westus"
    resource_group_name            = "preprod_rg_01"
    address_space                  = ["10.0.0.0/16"]
    bgp_community                  = "12076:20000"
    dns_servers                    = ["10.1.0.4", "10.1.0.5"]
    flow_timeout_in_minutes        = 10
    private_endpoint_vnet_policies = "Disabled"
    tags = {
      env = "preprod"
    }
  }

  "vnet2" = {
    name                = "preprod-vnet-02"
    location            = "westus"
    resource_group_name = "preprod_rg_02"
    address_space       = ["10.2.0.0/16"]
  }
}

# Subnets

subnets = {
  subnet1 = {
    subnet_name                                   = "subnet-01"
    resource_group_name                           = "preprod_rg_01"
    virtual_network_name                          = "preprod-vnet-01"
    address_prefixes                              = ["10.0.1.0/24"]
    default_outbound_access_enabled               = true
    private_endpoint_network_policies             = "Disabled"
    private_link_service_network_policies_enabled = true
    service_endpoints                             = ["Microsoft.Storage", "Microsoft.Sql"]
  }

  subnet2 = {
    subnet_name                                   = "subnet-02"
    resource_group_name                           = "preprod_rg_01"
    virtual_network_name                          = "preprod-vnet-01"
    address_prefixes                              = ["10.0.2.0/24"]
    default_outbound_access_enabled               = false
    private_endpoint_network_policies             = "Disabled"
    private_link_service_network_policies_enabled = true
    service_endpoints                             = ["Microsoft.Storage"]
  }
  subnet3 = {
    subnet_name                                   = "subnet-03"
    resource_group_name                           = "preprod_rg_01"
    virtual_network_name                          = "preprod-vnet-01"
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
    resource_group_name                           = "preprod_rg_01"
    virtual_network_name                          = "preprod-vnet-01"
    address_prefixes                              = ["10.0.4.0/24"]
    default_outbound_access_enabled               = false
    private_endpoint_network_policies             = "Disabled"
    private_link_service_network_policies_enabled = true
    service_endpoints                             = ["Microsoft.Storage"]
  }
}


# Public IP Addresses

public_ip = {
  "pip1" = {
    pip_name                = "preprod-pip-01"
    resource_group_name     = "preprod_rg_01"
    location                = "westus"
    allocation_method       = "Static"
    sku                     = "Standard"
    sku_tier                = "Regional"
    ddos_protection_mode    = "Enabled"
    domain_name_label       = "mywebapp"
    domain_name_label_scope = "NoReuse"
    idle_timeout_in_minutes = 4
    ip_version              = "IPv4"
    tags = {
      env = "preprod"
    }
  }

  "pip3" = {
    pip_name            = "preprod-pip-03"
    resource_group_name = "preprod_rg_01"
    location            = "westus"
    allocation_method   = "Static"
  }
}

# Network Security Groups

nsgs = {
  nsg1 = {
    nsg_name            = "preprodnsg01"
    location            = "westus"
    resource_group_name = "preprod_rg_01"

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
      env = "preprod"
    }
  }

  nsg2 = {
    nsg_name            = "preprodnsg02"
    location            = "westus"
    resource_group_name = "preprod_rg_01"

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
      env = "preprod"
    }
  }
}

# Subnets and NSGs Association

subnet_nsg_assoc = {
  sub_nsg_assoc1 = {
    nsg_name             = "preprodnsg01"
    virtual_network_name = "preprod-vnet-01"
    subnet_name          = "subnet-01"
    resource_group_name  = "preprod_rg_01"
  }

  sub_nsg_assoc2 = {
    nsg_name             = "preprodnsg01"
    virtual_network_name = "preprod-vnet-01"
    subnet_name          = "subnet-02"
    resource_group_name  = "preprod_rg_01"
  }
}

# Bastion Host

# bastion_hosts = {
#   bastion1 = {
#     bastion_host_name         = "preprod-bastion-host"
#     resource_group_name       = "preprod_rg_01"
#     location                  = "westus"
#     sku                       = "Standard"
#     virtual_network_name      = "preprod-vnet-01"
#     subnet_name               = "AzureBastionSubnet"
#     pip_name                  = "preprod-pip-03"
#     copy_paste_enabled        = true
#     file_copy_enabled         = true
#     ip_connect_enabled        = true
#     kerberos_enabled          = false
#     scale_units               = 3
#     shareable_link_enabled    = true
#     tunneling_enabled         = true
#     session_recording_enabled = false
#     # zones = ["1"]

#     ip_configuration = {
#       name = "bastion-ipconfig"
#     }

#     tags = {
#       environment = "preprod"
#       project     = "bastion-sample"
#     }
#   }
# }

# Key Vault and Key Vault Secrets

key_vaults = {
  kv1 = {
    key_vault_name              = "dkcprodkv09"
    location                    = "westus"
    resource_group_name         = "preprod_rg_01"
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
      environment = "preprod"
      owner       = "bhai"
    }
  }
}

key_vault_secrets = {
  vm_user = {
    secret_name         = "vm-username"
    secret_value        = "adminuser"
    key_vault_name      = "dkcprodkv09"
    resource_group_name = "preprod_rg_01"
  }

  vm_pass = {
    secret_name         = "vm-password"
    secret_value        = "Bbpl@#123456"
    key_vault_name      = "dkcprodkv09"
    resource_group_name = "preprod_rg_01"
  }

  storage_user = {
    secret_name         = "db-username"
    secret_value        = "dbuser"
    key_vault_name      = "dkcprodkv09"
    resource_group_name = "preprod_rg_01"
  }

  storrage_pass = {
    secret_name         = "db-password"
    secret_value        = "Bbpl@#123456"
    key_vault_name      = "dkcprodkv09"
    resource_group_name = "preprod_rg_01"
  }
}

# Network Interface & VMs Configuration

vms = {
  "vm1" = {
    # NIC -    
    nic_name             = "preprod-nic-01"
    location             = "westus"
    resource_group_name  = "preprod_rg_01"
    subnet_name          = "subnet-01"
    virtual_network_name = "preprod-vnet-01"
    # pip_name              = "preprod-pip-01"
    # network_interface_ids = [""]
    ip_configuration = {
      ip_config_name                = "ipconfig1"
      private_ip_address_allocation = "Dynamic"
    }

    # VM -
    vm_name        = "app-vm-01"
    size           = "Standard_B1s"
    key_vault_name = "dkcprodkv09"
    secret_name    = "vm-username"
    secret_value   = "vm-password"

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
      environment = "preprod"
      owner       = "team-app"
    }
  }

  "vm2" = {
    # NIC -    
    nic_name             = "preprod-nic-02"
    location             = "westus"
    resource_group_name  = "preprod_rg_01"
    subnet_name          = "subnet-02"
    virtual_network_name = "preprod-vnet-01"
    # pip_name             = "preprod-pip-02"
    ip_configuration = {
      ip_config_name                = "ipconfig1"
      private_ip_address_allocation = "Dynamic"
    }
    # VM -
    vm_name        = "db-vm-01"
    size           = "Standard_B1s"
    key_vault_name = "dkcprodkv09"
    secret_name    = "db-username"
    secret_value   = "db-password"
    # network_interface_ids = [""]
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
      environment = "prod"
      role        = "database"
    }
  }
}

storage_accounts = {
  "stg1" = {
    name                     = "dkcstorageaccount01"
    resource_group_name      = "preprod_rg_01"
    location                 = "westus"
    account_tier             = "Standard"
    account_replication_type = "LRS"
    access_tier              = "Hot"
  }
}

sql_servers = {
  "server1" = {
    name                          = "dkcsqlserver99"
    resource_group_name           = "preprod_rg_02"
    location                      = "West US 2"
    version                       = "12.0"
    administrator_login           = "sqladmin"
    administrator_login_password  = "P@ssword123!"
    connection_policy             = "Default"
    minimum_tls_version           = "1.2"
    public_network_access_enabled = true
    tags                          = { Environment = "preprod" }
  }
}

sql_databases = {
  "db1" = {
    db_name             = "mydb1"
    sql_server_name     = "dkcsqlserver01"
    resource_group_name = "preprod_rg_02"
    sku_name            = "GP_S_Gen5_2"
    max_size_gb         = 5
    short_term_retention_policy = {
      retention_days = 7
    }
    threat_detection_policy = {
      state                = "Enabled"
      email_account_admins = "Enabled"
      retention_days       = 30
    }
  }
}











