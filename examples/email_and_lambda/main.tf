terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.61.0"
    }
  }
  required_version = "~> 1.5.0"
}

provider "aws" {
  region = "eu-west-2"
}

module "sns" {
  source = "github.com/sudoblark/sudoblark.terraform.module.aws.sns?ref=1.0.1"

  application_name = var.application_name
  environment      = var.environment
  raw_sns_topics   = local.raw_sns_topics
}