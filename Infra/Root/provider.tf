terraform {
    required_providers {
      azurerm = {
        source = "hashicorp/azurerm"
        version = "4.10.0"
      }

      random = {
        source = "hashicorp/random"
        version = "3.1.0"
      }
    }
}

provider "azurerm" {
    features {}
    subscription_id = "Provide_Subscription_id"
}

# terraform {
#   backend "azurerm" {
#     resource_group_name  = "im-cc-state-storage-rg" 
#     storage_account_name = "im-cc-state-storage"                     
#     container_name       = "tfstate"                      
#     key                  = "dev.terraform.tfstate"       
#   }
# }