terraform {
    required_providers {
        azurerm = {
            source  = "hashicorp/azurerm"
            version = "~>3.34.0"
        }
    }
#    backend "azurerm" {
#        resource_group_name = "terraform_demo"
#        storage_account_name = "rarytesttfstate"
#        container_name = "tfstatedemo"
#        key = "SuperSpecialName.tfstatetags"
#    }
}

provider "azurerm" {
  features {}
}