terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

provider "azurerm" {
  features {}
}

variable "rary-prefix" {}

variable "region" {
  type        = string
  default     = "North Europe"
  description = "The Azure region to deploy resources"
  validation {
    condition     = contains(["UK South", "UK West", "North Europe", "West Europe", "East US", "West US"], var.region)
    error_message = "Invalid region"
  }
}

variable "tags" {
  type        = map(any)
  description = "A map of tags"
}

resource "azurerm_resource_group" "contoso_rg" {
  name     = "${var.rary-prefix}_rg"
  location = var.region
  tags     = var.tags
}

resource "azurerm_resource_group" "contoso_dev_rg" {
  name     = "${var.rary-prefix}_dev_rg"
  location = var.region
  tags     = var.tags
}