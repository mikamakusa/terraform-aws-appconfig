resource "aws_appconfig_application" "this" {
  count       = length(var.application)
  name        = lookup(var.application[count.index], "name")
  description = lookup(var.application[count.index], "description")
  tags        = merge(var.tags, data.aws_default_tags.this.tags, lookup(var.application[count.index], "tags"))
}

resource "aws_appconfig_configuration_profile" "this" {
  count              = length(var.application) == 0 ? 0 : length(var.configuration_profile)
  application_id     = try(element(aws_appconfig_application.this.*.id, lookup(var.configuration_profile[count.index], "application_id")))
  location_uri       = lookup(var.configuration_profile[count.index], "location_uri")
  name               = lookup(var.configuration_profile[count.index], "name")
  description        = lookup(var.configuration_profile[count.index], "description")
  kms_key_identifier = try(element(module.kms.*.key_arn, lookup(var.configuration_profile[count.index], "kms_key_id")))
  retrieval_role_arn = var.configuration_profile_retrieval_role_arn
  tags               = merge(var.tags, data.aws_default_tags.this.tags, lookup(var.configuration_profile[count.index], "tags"))
  type               = lookup(var.configuration_profile[count.index], "type", "AWS.Freeform")

  dynamic "validator" {
    for_each = try(lookup(var.configuration_profile[count.index], "validator") == null ? [] : ["validator"])
    iterator = val
    content {
      type    = lookup(val.value, "type")
      content = lookup(val.value, "type") == "LAMBDA" ? try(data.aws_lambda_function.this.arn) : lookup(val.value, "content")
    }
  }
}

resource "aws_appconfig_deployment" "this" {
  count                    = (length(var.application) && length(var.configuration_profile) && length(var.hosted_configuration_version) && length(var.environment) && length(var.deployment_strategy)) == 0 ? 0 : length(var.application)
  application_id           = try(element(aws_appconfig_application.this.*.id, lookup(var.deployment[count.index], "application_id")))
  configuration_profile_id = try(element(aws_appconfig_configuration_profile.this.*.id, lookup(var.deployment[count.index], "configuration_profile_id")))
  configuration_version    = try(element(aws_appconfig_hosted_configuration_version.this.*.id, lookup(var.deployment[count.index], "configuration_version")))
  deployment_strategy_id   = try(element(aws_appconfig_deployment_strategy.this.*.id, lookup(var.deployment[count.index], "deployment_strategy_id")))
  environment_id           = try(element(aws_appconfig_environment.this.*.id, lookup(var.deployment[count.index], "environment_id")))
  kms_key_identifier       = try(element(module.kms.*.key_arn, lookup(var.deployment[count.index], "kms_key_id")))
  description              = lookup(var.deployment[count.index], "description")
  tags                     = merge(var.tags, data.aws_default_tags.this.tags, lookup(var.deployment[count.index], "tags"))
}

resource "aws_appconfig_deployment_strategy" "this" {
  count                          = length(var.deployment_strategy)
  deployment_duration_in_minutes = lookup(var.deployment_strategy[count.index], "deployment_duration_in_minutes")
  growth_factor                  = lookup(var.deployment_strategy[count.index], "growth_factor")
  name                           = lookup(var.deployment_strategy[count.index], "name")
  replicate_to                   = lookup(var.deployment_strategy[count.index], "replicate_to")
  description                    = lookup(var.deployment_strategy[count.index], "description")
  final_bake_time_in_minutes     = lookup(var.deployment_strategy[count.index], "final_bake_time_in_minutes")
  growth_type                    = lookup(var.deployment_strategy[count.index], "growth_type", "LINEAR")
  tags                           = merge(var.tags, data.aws_default_tags.this.tags, lookup(var.deployment_strategy[count.index], "tags"))
}

resource "aws_appconfig_environment" "this" {
  count          = length(var.application) == 0 ? 0 : length(var.environment)
  application_id = try(element(aws_appconfig_application.this.*.id, lookup(var.environment[count.index], "application_id")))
  name           = lookup(var.environment[count.index], "name")
  description    = lookup(var.environment[count.index], "description")
  tags           = merge(var.tags, data.aws_default_tags.this.tags, lookup(var.environment[count.index], "tags"))

  dynamic "monitor" {
    for_each = try(lookup(var.environment[count.index], "monitor") == null ? [] : ["monitor"])
    content {
      alarm_arn      = var.aws_cloudwatch_metric_alarm
      alarm_role_arn = data.aws_iam_role.this.arn
    }
  }
}

resource "aws_appconfig_extension" "this" {
  count       = length(var.extension)
  name        = lookup(var.extension[count.index], "name")
  description = lookup(var.extension[count.index], "description")
  tags        = merge(var.tags, data.aws_default_tags.this.tags, lookup(var.extension[count.index], "tags"))

  dynamic "action_point" {
    for_each = try(lookup(var.extension[count.index], "action_point") == null ? [] : ["action_point"])
    iterator = act
    content {
      point = lookup(act.value, "point")

      dynamic "action" {
        for_each = try(lookup(act.value, "action") == null ? [] : ["action"])
        content {
          name        = lookup(action.value, "name")
          role_arn    = var.extension_action_role_arn
          uri         = lookup(action.value, "uri")
          description = lookup(action.value, "description")
        }
      }
    }
  }

  dynamic "parameter" {
    for_each = try(lookup(var.extension[count.index], "parameter") == null ? [] : ["parameter"])
    iterator = par
    content {
      name        = lookup(par.value, "name")
      required    = lookup(par.value, "required")
      description = lookup(par.value, "description")
    }
  }
}

resource "aws_appconfig_extension_association" "this" {
  count         = (length(var.extension) && length(var.application)) == 0 ? 0 : length(var.extension_association)
  extension_arn = try(element(aws_appconfig_extension.this.*.arn, lookup(var.extension_association[count.index], "extension_id")))
  resource_arn  = try(element(aws_appconfig_application.this.*.arn, lookup(var.extension_association[count.index], "resource_id")))
}

resource "aws_appconfig_hosted_configuration_version" "this" {
  count                    = (length(var.application) && length(var.configuration_profile)) == 0 ? 0 : length(var.hosted_configuration_version)
  application_id           = try(element(aws_appconfig_application.this.*.id, lookup(var.hosted_configuration_version[count.index], "application_id")))
  configuration_profile_id = try(element(aws_appconfig_configuration_profile.this.*.id, lookup(var.hosted_configuration_version[count.index], "configuration_profile_id")))
  content                  = jsonencode(lookup(var.hosted_configuration_version[count.index], "content"))
  content_type             = lookup(var.hosted_configuration_version[count.index], "content_type")
  description              = lookup(var.hosted_configuration_version[count.index], "description")
}