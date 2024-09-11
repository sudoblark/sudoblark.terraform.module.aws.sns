locals {
  target_permissions = { for identifier, topic in flatten([
    for topic in var.raw_sns_topics : [
      for i, target in topic.subscriptions : {
        index : format("%s/%s", topic.suffix, target.name),
        sns_topic_suffix : topic.suffix,
        lambda_name : target.name,
        topic_arn : aws_sns_topic.topics[topic.suffix].arn,
      } if target.protocol == "lambda"
    ]
    ]) : topic.index => topic
  }
}

resource "aws_lambda_permission" "allow_lambda_execution_from_sns" {
  for_each = { for permission in local.target_permissions : permission.index => permission }

  statement_id  = format("AllowExecutionFromSNSTopic-%s", each.value["sns_topic_suffix"])
  action        = "lambda:InvokeFunction"
  function_name = each.value["lambda_name"]
  principal     = "sns.amazonaws.com"
  source_arn    = each.value["topic_arn"]
}