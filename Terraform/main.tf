terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
    }
  }
  backend "azurerm" {
      resource_group_name  = "tfstate"
      storage_account_name = "tfstate31858"
      container_name       = "tfstate"
      key                  = "terraform.tfstate"
  }
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

data "azurerm_client_config" "current" {
}

resource "azurerm_resource_group" "rg" {
  name     = var.rg_name
  location = var.location
}
resource "azurerm_virtual_network" "vnet" {
  depends_on = [ azurerm_resource_group.rg ]
  name                = var.vnet_name
  address_space       = ["10.240.10.0/24"]
  resource_group_name = var.rg_name
  location = var.location
}

module "aci" {
  depends_on = [azurerm_resource_group.rg]
  source = "./modules/aci"
  
  gh_pat = var.gh_pat
  gh_repo_url = var.gh_repo_url
  resourceGroupName = azurerm_resource_group.rg.name
  vnetName = azurerm_virtual_network.vnet.name
}

