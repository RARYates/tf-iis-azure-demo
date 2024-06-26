terraform {
    required_providers {
        azurerm = {
            source  = "hashicorp/azurerm"
            version = "~>3.96.0"
        }
    }
    backend "azurerm" {
        resource_group_name = "terraform_demo"
        storage_account_name = "rarytesttfstate"
        container_name = "tfstatedemo"
        key = "iis.tfstate"
        use_oidc = true
    }
}

provider "azurerm" {
  features {}
}