## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_appconfig_application.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appconfig_application) | resource |
| [aws_appconfig_configuration_profile.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appconfig_configuration_profile) | resource |
| [aws_appconfig_deployment.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appconfig_deployment) | resource |
| [aws_appconfig_deployment_strategy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appconfig_deployment_strategy) | resource |
| [aws_appconfig_environment.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appconfig_environment) | resource |
| [aws_appconfig_extension.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appconfig_extension) | resource |
| [aws_appconfig_extension_association.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appconfig_extension_association) | resource |
| [aws_appconfig_hosted_configuration_version.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appconfig_hosted_configuration_version) | resource |
| [aws_default_tags.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/default_tags) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_application"></a> [application](#input\_application) | n/a | <pre>list(object({<br>    id          = number<br>    name        = string<br>    description = optional(string)<br>    tags        = optional(map(string))<br>  }))</pre> | `[]` | no |
| <a name="input_configuration_profile"></a> [configuration\_profile](#input\_configuration\_profile) | n/a | <pre>list(object({<br>    id                 = number<br>    application_id     = any<br>    location_uri       = string<br>    name               = string<br>    description        = optional(string)<br>    kms_key_identifier = optional(any)<br>    retrieval_role_arn = optional(any)<br>    tags               = optional(map(string))<br>    type               = optional(string)<br>    validator = optional(list(object({<br>      type    = string<br>      content = optional(string)<br>    })))<br>  }))</pre> | `[]` | no |
| <a name="input_deployment"></a> [deployment](#input\_deployment) | n/a | <pre>list(object({<br>    id                       = number<br>    application_id           = any<br>    configuration_profile_id = any<br>    configuration_version    = any<br>    deployment_strategy_id   = any<br>    environment_id           = any<br>    description              = optional(string)<br>    kms_key_identifier       = optional(any)<br>    tags                     = optional(map(string))<br>  }))</pre> | n/a | yes |
| <a name="input_deployment_strategy"></a> [deployment\_strategy](#input\_deployment\_strategy) | n/a | <pre>list(object({<br>    id                             = number<br>    deployment_duration_in_minutes = number<br>    growth_factor                  = number<br>    name                           = string<br>    replicate_to                   = string<br>    description                    = optional(string)<br>    final_bake_time_in_minutes     = optional(number)<br>    growth_type                    = optional(string)<br>    tags                           = optional(map(string))<br>  }))</pre> | `[]` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | n/a | <pre>list(object({<br>    id             = number<br>    application_id = any<br>    name           = string<br>    description    = optional(string)<br>    tags           = optional(map(string))<br>    monitor = optional(list(object({<br>      alarm_id       = any<br>      alarm_role_arn = optional(string)<br>    })))<br>  }))</pre> | `[]` | no |
| <a name="input_extension"></a> [extension](#input\_extension) | n/a | <pre>list(object({<br>    id          = number<br>    name        = ""<br>    description = ""<br>    tags        = {}<br>    action_point = optional(list(object({<br>      point = string<br>      action = optional(list(object({<br>        name        = string<br>        role_arn    = string<br>        uri         = string<br>        description = optional(string)<br>      })))<br>    })))<br>    parameter = optional(list(object({<br>      name        = string<br>      required    = optional(bool)<br>      description = optional(string)<br>    })))<br><br>  }))</pre> | `[]` | no |
| <a name="input_extension_association"></a> [extension\_association](#input\_extension\_association) | n/a | <pre>list(object({<br>    id           = number<br>    extension_id = any<br>    resource_id  = any<br>  }))</pre> | `[]` | no |
| <a name="input_hosted_configuration_version"></a> [hosted\_configuration\_version](#input\_hosted\_configuration\_version) | n/a | <pre>list(object({<br>    id                       = number<br>    application_id           = any<br>    configuration_profile_id = any<br>    content                  = string<br>    content_type             = string<br>    description              = optional(string)<br>  }))</pre> | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map(string)` | `{}` | no |

## Outputs

No outputs.
