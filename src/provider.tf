terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.14.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

provider "random" {}

terraform {
  required_version = "~> 1.1.0"
  experiments      = [module_variable_optional_attrs]
}