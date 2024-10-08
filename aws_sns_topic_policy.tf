locals {
  actual_policies = flatten([
    for topic in var.raw_sns_topics : {
      arn    = aws_sns_topic.topics[topic.suffix].arn
      policy = data.aws_iam_policy_document.topic_policies[topic.suffix].json
      suffix = topic.suffix
    } if length(topic.iam_policy_statements) > 0
  ])
}

resource "aws_sns_topic_policy" "policy" {
  for_each = { for topic in local.actual_policies : topic.suffix => topic }

  arn = each.value["arn"]

  policy = each.value["policy"]

  depends_on = [
    data.aws_iam_policy_document.topic_policies,
    aws_sns_topic.topics
  ]
}