#Fetch the subscription details
 data "azurerm_subscription" "current" {
 }
#Fetch the Tenant and client details
data "azurerm_client_config" "current" {}

#Fetch the Existing Resource Group details 
data "azurerm_resource_group" "example" {
  name = "Test_VM"
}
#Fetch the Existing Virtual Network details
data "azurerm_virtual_network" "example-vnet" {
  name                = "v-network"
  resource_group_name = data.azurerm_resource_group.example.name
}
#Fetch the Existing Subnet Details
data "azurerm_subnet" "example" {
  name                 = "subnet1"
  virtual_network_name = data.azurerm_virtual_network.example-vnet.name
  resource_group_name  = data.azurerm_resource_group.example.name
}
#Fetch the Existing Image Definition and Latest Image Version
data "azurerm_shared_image" "example-sig" {
  name                = "windDc2022"       ## Image definition name
  gallery_name        = "AzurepackerImages" ##Azure Shared Gallery name
  resource_group_name = "rg-packer-acg"   ##Resource group name
}

data "azurerm_shared_image_version" "example" {
  name                = "1.0.0"
  image_name          = "my-image"
  gallery_name        = "my-image-gallery"
  resource_group_name = "example-resources"
}

#Create Network Interface card 
resource "azurerm_network_interface" "example-nic" {
  name                = "packerimgdemo-nic"
  location            = data.azurerm_resource_group.example.location
  resource_group_name = data.azurerm_resource_group.example.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.azurerm_subnet.example.id
    private_ip_address_allocation = "Dynamic"
  }
}
#Create a Windows Virtual Machine
# resource "azurerm_windows_virtual_machine" "example-vm" {
#   name                = "packerimgdemo"
#   resource_group_name = data.azurerm_resource_group.example.name
#   location            = data.azurerm_resource_group.example.location
#   size                = "Standard_D2s_v3"
#   admin_username      =  data.azurerm_key_vault_secret.vm_username.value
#   admin_password      =  data.azurerm_key_vault_secret.vm_password.value
#   depends_on = [data.azurerm_key_vault_secret.vm_password, data.azurerm_key_vault_secret.vm_username]
#   identity {
#       type = "SystemAssigned"
#   }
#   network_interface_ids = [
#     azurerm_network_interface.example-nic.id
#   ]
#   os_disk {
#     caching              = "ReadWrite"
#     storage_account_type = "Standard_LRS"
#   }
#   source_image_id = data.azurerm_shared_image.example-sig.id
#   lifecycle {
#      ignore_changes = [
#       identity

#     ]  
#    }
# }
#Create a Linux  Virtual Machine

resource "azurerm_linux_virtual_machine" "example-vm" {
  name                = "linuxvm-poctest"
  resource_group_name = data.azurerm_resource_group.example.name
  location            = data.azurerm_resource_group.example.location
  size                = "Standard_D2s_v3"
  admin_username      =  data.azurerm_key_vault_secret.vm_username.value
  admin_password      =  data.azurerm_key_vault_secret.vm_password.value
  depends_on = [data.azurerm_key_vault_secret.vm_password, data.azurerm_key_vault_secret.vm_username]
  identity {
      type = "SystemAssigned"
  }
  network_interface_ids = [
    azurerm_network_interface.example-nic.id
  ]
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_id = data.azurerm_shared_image.example-sig.id
  lifecycle {
     ignore_changes = [
      identity

    ]  
   }
}

# Fetch the existing Key Vault
data "azurerm_key_vault" "kv" {
  name                = "kvpacker01"
  resource_group_name = data.azurerm_resource_group.example.name
  #tenant_id = data.azurerm_client_config.current.tenant_id
  #depends_on = [azurerm_windows_virtual_machine.example-vm]
}
# Grant VM Managed Identity Access to Key Vault
resource "azurerm_key_vault_access_policy" "vm_access_policy" {
  key_vault_id = data.azurerm_key_vault.kv.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = azurerm_windows_virtual_machine.example-vm.identity[0].principal_id

  secret_permissions = [
    "Get", "List",
  ]
}

# Fetch the username and password secrets from Key Vault
data "azurerm_key_vault_secret" "vm_username" {
  name         = "vmUsername"               # Name of the username secret in the Key Vault
  key_vault_id = data.azurerm_key_vault.kv.id
}

data "azurerm_key_vault_secret" "vm_password" {
  name         = "vmPassword"               # Name of the password secret in the Key Vault
  key_vault_id = data.azurerm_key_vault.kv.id
}

 output "vm_private_ip" {
  description = "The private IP address of the Windows VM"
  value       = azurerm_network_interface.example-nic.private_ip_address
}

output "current_subscription_display_name" {
  value = data.azurerm_subscription.current.display_name
}