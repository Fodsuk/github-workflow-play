variable "policy_host" {
  type = object({
    management_group_id = string
  })
  description = "where should the policy resources get created"

  default = null
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
    policy_file = string
    set_name    = string
  }))

  default = {}
}