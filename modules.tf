module "kms" {
  source = "./modules/terraform-aws-kms"
  key    = var.kms_key
}