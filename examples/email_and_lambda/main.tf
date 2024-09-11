module "sns" {
  source = "git::ssh://git@github.com/sudoblark/sudoblark.terraform.module.aws.sns?ref=1.0.0"

  application_name = var.application_name
  environment      = var.environment
  raw_sns_topics   = local.raw_sns_topics
}