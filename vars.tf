## TAGS

variable "tags" {
  type    = map(string)
  default = {}
}

## RESOURCES

variable "application" {
  type = list(object({
    id          = number
    name        = string
    description = optional(string)
    tags        = optional(map(string))
  }))
  default = []
}

variable "configuration_profile" {
  type = list(object({
    id                 = number
    application_id     = any
    location_uri       = string
    name               = string
    description        = optional(string)
    kms_key_identifier = optional(any)
    retrieval_role_arn = optional(any)
    tags               = optional(map(string))
    type               = optional(string)
    validator = optional(list(object({
      type    = string
      content = optional(string)
    })))
  }))
  default = []
}

variable "deployment" {
  type = list(object({
    id                       = number
    application_id           = any
    configuration_profile_id = any
    configuration_version    = any
    deployment_strategy_id   = any
    environment_id           = any
    description              = optional(string)
    kms_key_identifier       = optional(any)
    tags                     = optional(map(string))
  }))
}

variable "deployment_strategy" {
  type = list(object({
    id                             = number
    deployment_duration_in_minutes = number
    growth_factor                  = number
    name                           = string
    replicate_to                   = string
    description                    = optional(string)
    final_bake_time_in_minutes     = optional(number)
    growth_type                    = optional(string)
    tags                           = optional(map(string))
  }))
  default = []
}

variable "environment" {
  type = list(object({
    id             = number
    application_id = any
    name           = string
    description    = optional(string)
    tags           = optional(map(string))
    monitor = optional(list(object({
      alarm_id       = any
      alarm_role_arn = optional(string)
    })))
  }))
  default = []
}

variable "extension" {
  type = list(object({
    id          = number
    name        = ""
    description = ""
    tags        = {}
    action_point = optional(list(object({
      point = string
      action = optional(list(object({
        name        = string
        role_arn    = string
        uri         = string
        description = optional(string)
      })))
    })))
    parameter = optional(list(object({
      name        = string
      required    = optional(bool)
      description = optional(string)
    })))

  }))
  default = []
}

variable "extension_association" {
  type = list(object({
    id           = number
    extension_id = any
    resource_id  = any
  }))
  default = []
}

variable "hosted_configuration_version" {
  type = list(object({
    id                       = number
    application_id           = any
    configuration_profile_id = any
    content                  = string
    content_type             = string
    description              = optional(string)
  }))
  default = []
}
