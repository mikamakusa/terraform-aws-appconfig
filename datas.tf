data "aws_default_tags" "this" {}

data "aws_lambda_function" "this" {
  count         = try(var.lambda_function_name ? 1 : 0)
  function_name = try(var.lambda_function_name)
}

data "aws_iam_role" "this" {
  count = try(var.monitor_alarm_role ? 1 : 0)
  name  = try(var.monitor_alarm_role)
}