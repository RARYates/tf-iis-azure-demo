/* Should spin up
* RG
* VM
* Install IIS on VM
* Point at Website in Azure Files Account and deploy it
*/

# My new comment

resource "azurerm_resource_group" "website" {
  name     = "website-iis"
  location = "westus2"
}

resource "azurerm_virtual_network" "website" {
  name                = "website"
  address_space       = ["10.50.0.0/16"]
  location            = azurerm_resource_group.website.location
  resource_group_name = azurerm_resource_group.website.name
}

resource "azurerm_subnet" "website" {
  name                 = "website"
  resource_group_name  = azurerm_resource_group.website.name
  virtual_network_name = azurerm_virtual_network.website.name
  address_prefixes     = ["10.50.50.0/24"]
}

resource "azurerm_network_interface" "website" {
  name                = "website-nic"
  location            = azurerm_resource_group.website.location
  resource_group_name = azurerm_resource_group.website.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.website.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.website.id
  }
}

resource "azurerm_windows_virtual_machine" "website" {
  name                = "org-iis-website"
  resource_group_name = azurerm_resource_group.website.name
  location            = azurerm_resource_group.website.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  admin_password      = "P@$$w0rd1234!"
  network_interface_ids = [
    azurerm_network_interface.website.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
}

resource "azurerm_virtual_machine_extension" "vm_extension_install_iis" {
  name                       = "vm_extension_install_iis"
  virtual_machine_id         = azurerm_windows_virtual_machine.website.id
  publisher                  = "Microsoft.Compute"
  type                       = "CustomScriptExtension"
  type_handler_version       = "1.10"
  auto_upgrade_minor_version = true

  settings = <<SETTINGS
    {
        "commandToExecute": "powershell -ExecutionPolicy Unrestricted Install-WindowsFeature -Name Web-Server -IncludeAllSubFeature -IncludeManagementTools"
    }
SETTINGS

#protected_settings = <<PROTECTED_SETTINGS
#    {
#        "commandToExecute": "myExecutionCommand",
#        "storageAccountName": "myStorageAccountName",
#        "storageAccountKey": "myStorageAccountKey",
#        "managedIdentity" : {
#    }
#PROTECTED_SETTINGS
}

resource "azurerm_public_ip" "website" {
  name                = "iis-website"
  resource_group_name = azurerm_resource_group.website.name
  location            = azurerm_resource_group.website.location
  allocation_method   = "Dynamic"
}