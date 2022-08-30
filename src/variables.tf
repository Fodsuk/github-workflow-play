variable "system" {
  type    = string
  default = "plt"
}

variable "environment" {
  type = string
}

variable "purpose" {
  type    = string
  default = "policies"
}

variable "location" {
  type        = string
  description = "Default location e.g. uksouth"
}

variable "policy_scope" {
  type = object({
    management_group_id = optional(string)
  })
  default = {
    management_group_id = null
  }
  description = <<-DESCRIPTION
    Where policy sets and definitions will be scoped.
    If a management_group_id is not provided then the default scope is the current subscription.
  DESCRIPTION
}

variable "policy_sets" {
  type = map(object({
    display_name = string
    description  = string
    metadata     = map(string)
  }))

  default = {}
}

variable "policies" {
  type = map(object({
    set_key                         = optional(string)
    policy_file                     = string
    managed_identity_required_roles = optional(list(string))
  }))

  default = {}
}

variable "policy_resource_group_assignments" {
  type = map(object({
    policy_key                = string
    display_name              = string
    description               = string
    resource_group_id         = string
    metadata                  = map(string)
    parameters_json           = optional(string)
    managed_identity_required = bool
    non_compliance_message    = string
  }))

  default = {}
}

variable "policy_management_group_assignments" {
  type = map(object({
    policy_key                = string
    display_name              = string
    description               = string
    management_group_id       = string
    metadata                  = map(string)
    parameters_json           = optional(string)
    managed_identity_required = bool
    non_compliance_message    = string
  }))

  default = {}
}
