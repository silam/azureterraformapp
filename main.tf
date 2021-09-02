provider "azurerm" {

    subscription_id = "264a2087-c116-4fbf-a051-7209921e0896"
    tenant_id       = "cdd071d0-805d-4b10-bac9-ee8225b4cbdc"

 
    features {}
}
variable "imagebuild" {
  type        = string
  description = "Latest Image Build"
}
terraform {
    backend "azurerm" {
        resource_group_name  = "tf_rg_blobstore"
        storage_account_name = "tfstoreaccountsilam"
        container_name       = "tfstate"
        key                  = "terraform.tfstate"
    }
}

resource "azurerm_resource_group" "tf_test" {
    name = "tfmainrg"
    location = "eastus"
}

resource "azurerm_container_group" "tfcg_test" {
  name                      = "weatherapi"
  location                  = azurerm_resource_group.tf_test.location
  resource_group_name       = azurerm_resource_group.tf_test.name

  ip_address_type     = "public"
  dns_name_label      = "sichilam"
  os_type             = "Linux"

  container {
    name            = "weatherapi"
    image           = "sichilam/weatherapi:${var.imagebuild}"
    cpu             = "1"
    memory          = "1"

    ports {
        port        = 80
        protocol    = "TCP"
    }
  }
}
