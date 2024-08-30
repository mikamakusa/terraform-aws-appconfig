## TAGS

variable "tags" {
  type    = map(string)
  default = {}
}

## DATAS

variable "lambda_function_name" {
  type    = string
  default = null
}

## IAM

variable "configuration_profile_retrieval_role_arn" {
  type    = string
  default = null
}

variable "extension_action_role_arn" {
  type    = string
  default = null
}

variable "monitor_alarm_role" {
  type    = string
  default = null
}

## CLOUDWATCH_METRIC

variable "aws_cloudwatch_metric_alarm" {
  type    = string
  default = null
}

## MODULES

variable "kms_key" {
  type    = any
  default = []
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
    kms_key_id         = optional(any)
    retrieval_role_arn = optional(any)
    tags               = optional(map(string))
    type               = optional(string)
    validator = optional(list(object({
      type    = string
      content = optional(string)
    })))
  }))
  default = []

  validation {
    condition     = length([for a in var.configuration_profile : true if contains(["AWS.AppConfig.FeatureFlags", "AWS.Freeform"], a.type)]) == length(var.configuration_profile)
    error_message = "Valid values: AWS.AppConfig.FeatureFlags and AWS.Freeform."
  }

  validation {
    condition     = length([for b in var.configuration_profile : true if contains(["JSON_SCHEMA", "LAMBDA"], b.validator.type)]) == length(var.configuration_profile)
    error_message = "Valid values: JSON_SCHEMA or LAMBDA."
  }
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
    kms_key_id               = optional(any)
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

  validation {
    condition     = length([for b in var.deployment_strategy : true if contains(["NONE", "SSM_DOCUMENT"], b.replicate_to)]) == length(var.deployment_strategy)
    error_message = "Valid values: NONE or SSM_DOCUMENT."
  }

  validation {
    condition     = length([for a in var.deployment_strategy : true if contains(["LINEAR", "EXPONENTIAL"], a.growth_type)]) == length(var.deployment_strategy)
    error_message = "Valid values: LINEAR or EXPONENTIAL."
  }

  validation {
    condition     = length([for c in var.deployment_strategy : true if c.deployment_duration_in_minutes >= 0 && c.deployment_duration_in_minutes <= 1440]) == length(var.deployment_strategy)
    error_message = "Minimum value of 0, maximum value of 1440."
  }

  validation {
    condition     = length([for d in var.deployment_strategy : true if d.growth_factor >= 1.0 && d.growth_factor <= 100.0]) == length(var.deployment_strategy)
    error_message = "Minimum value of 1.0, maximum value of 100.0."
  }

  validation {
    condition     = length([for e in var.deployment_strategy : true if length(e.name) >= 1 && length(e.name) <= 64]) == length(var.deployment_strategy)
    error_message = "Must be between 1 and 64 characters in length."
  }

  validation {
    condition     = length([for f in var.deployment_strategy : true if length(f.description) <= 1024]) == length(var.deployment_strategy)
    error_message = "Can be at most 1024 characters."
  }

  validation {
    condition     = length([for g in var.deployment_strategy : true if g.final_bake_time_in_minutes >= 0 && g.final_bake_time_in_minutes <= 1440]) == length(var.deployment_strategy)
    error_message = "Minimum value of 0, maximum value of 1440."
  }
}

variable "environment" {
  type = list(object({
    id             = number
    application_id = any
    name           = string
    description    = optional(string)
    tags           = optional(map(string))
    monitor = optional(list(object({
      alarm_id       = optional(any)
      alarm_role_arn = optional(any)
    })))
  }))
  default = []

  validation {
    condition     = length([for a in var.environment : true if length(a.name) >= 1 && length(a.name) <= 64]) == length(var.environment)
    error_message = "Must be between 1 and 64 characters in length."
  }

  validation {
    condition     = length([for b in var.environment : true if length(b.description) <= 1024]) == length(var.environment)
    error_message = "Can be at most 1024 characters."
  }
}

variable "extension" {
  type = list(object({
    id          = number
    name        = string
    description = optional(string)
    tags        = optional(map(string))
    action_point = optional(list(object({
      point = string
      action = optional(list(object({
        name        = string
        role_arn    = optional(any)
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

  validation {
    condition     = length([for a in var.extension : true if contains(["PRE_CREATE_HOSTED_CONFIGURATION_VERSION", "PRE_START_DEPLOYMENT", "ON_DEPLOYMENT_START", "ON_DEPLOYMENT_STEP", "ON_DEPLOYMENT_BAKING", "ON_DEPLOYMENT_COMPLETE", "ON_DEPLOYMENT_ROLLED_BACK"], a.action_point.point)]) == length(var.extension)
    error_message = "Valid points are PRE_CREATE_HOSTED_CONFIGURATION_VERSION, PRE_START_DEPLOYMENT, ON_DEPLOYMENT_START, ON_DEPLOYMENT_STEP, ON_DEPLOYMENT_BAKING, ON_DEPLOYMENT_COMPLETE, ON_DEPLOYMENT_ROLLED_BACK."
  }
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
