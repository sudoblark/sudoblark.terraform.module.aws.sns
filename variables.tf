# Input variable definitions
variable "environment" {
  description = "Which environment this is being instantiated in."
  type        = string
  validation {
    condition     = contains(["dev", "test", "prod"], var.environment)
    error_message = "Must be either dev, test or prod"
  }
}

variable "application_name" {
  description = "Name of the application utilising the resource resource."
  type        = string
}

variable "raw_sns_topics" {
  description = <<EOF

Data structure
---------------
A list of dictionaries, where each dictionary has the following attributes:

REQUIRED
---------
- suffix                : Suffix for the topic, will also be used as a unified index for Terraform resources.

- subscriptions          : A list of dictionaries, where each dictionary defines:
-- endpoint             : Actual endpoint to deliver to, see constraints for more information.
-- name                 : Friendly name for the endpoint, used for unique indexing in Terraform.
-- protocol             : Determines the subscription type, permissible types are: email, lambda

OPTIONAL
---------
- iam_policy_statements : A list of dictionaries where each dictionary is an IAM statement defining topic policy permissions.
-- Each dictionary in this list must define the following attributes:
--- sid: Friendly name for the policy, no spaces or special characters allowed
--- actions: A list of IAM actions the state machine is allowed to perform
--- resources: Which resource(s) the state machine may perform the above actions against
--- conditions    : An OPTIONAL list of dictionaries, which each defines:
---- test         : Test condition for limiting the action
---- variable     : Value to test
---- values       : A list of strings, denoting what to test for
--- principals    : An list of dictionaries, which each defines:
---- type         : A string defining what type the principle(s) is/are
---- identifiers  : A list of strings, where each string is an allowed principle

Constraints
---------
- if endpoints.protocol == lambda then:
-- endpoint must be ARN of a lambda function
-- name must be name of a lambda function
- if endpoints.protocol == email, then endpoint must be an email address

- Only lambda and email endpoints.protocol values are supported

EOF
  type = list(
    object({
      suffix = string,
      iam_policy_statements = list(
        object({
          sid       = string,
          actions   = list(string),
          resources = list(string),
          conditions = optional(list(
            object({
              test : string,
              variable : string,
              values = list(string)
            })
          ), [])
          principals = list(
            object({
              type        = string,
              identifiers = list(string)
            })
          )
        })
      ),
      subscriptions = list(
        object({
          endpoint : string,
          name : string,
          protocol : string
        })
      ),
    })
  )

  validation {
    condition = alltrue([
      for topic in var.raw_sns_topics : alltrue([
        for subscription in topic.subscriptions : alltrue([
          contains(["email", "lambda"], subscription.protocol)
        ])
      ])
    ])
    error_message = "Permissible protocol values are: email, lambda."
  }

  validation {
    condition = alltrue([
      for topic in var.raw_sns_topics : alltrue([
        for subscription in topic.subscriptions : alltrue([
          # Regex below is meant to match <ASCI>.@<ASCI>.<ASCI>[2,4 chars]
          (subscription.protocol == "email" && can(regex("^[[:ascii:]]+.@[[:ascii:]]+.[[:ascii:]]{2,4}$", subscription.endpoint))) ||
          (subscription.protocol != "email")
        ])
      ])
    ])
    error_message = "Email protocols require email addresses as an endpoint."
  }

  validation {
    condition = alltrue([
      for topic in var.raw_sns_topics : alltrue([
        for subscription in topic.subscriptions : alltrue([
          (subscription.protocol == "lambda" && can(regex("arn:aws:lambda", subscription.endpoint))) ||
          (subscription.protocol != "lambda")
        ])
      ])
    ])
    error_message = "Lambda protocols require lambda ARN as an endpoint."
  }
}