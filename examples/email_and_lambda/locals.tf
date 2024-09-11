locals {
  raw_sns_topics = [
    {
      suffix = "notify-me"
      iam_policy_statements = [
        {
          sid = "AllowPublishToSNS"
          actions = [
            "SNS:Publish"
          ]
          resources = [
            "arn:aws:sns:${data.aws_region.current_region.name}:${data.aws_caller_identity.current_account.account_id}:my-notification-lambda"
          ],
          principals = [
            {
              type        = "AWS"
              identifiers = ["allowed-principal-role"]
            }
          ]
        }
      ]
      subscriptions = [
        {
          name     = "my-notification-lambda"
          endpoint = "arn:aws:lambda:eu-west-1:<account>:function:my-notification-lambda"
          protocol = "lambda"
        },
        {
          name     = "example-email"
          endpoint = "hello@world.com"
          protocol = "email"
        },
      ]
    }
  ]
}