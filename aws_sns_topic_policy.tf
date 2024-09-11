resource "aws_sns_topic_policy" "policy" {
  for_each = { for topic in var.raw_sns_topics : topic.suffix => topic }

  arn = aws_sns_topic.topics[each.value["suffix"]].arn

  policy = data.aws_iam_policy_document.topic_policies[each.value["suffix"]].json

  depends_on = [
    data.aws_iam_policy_document.topic_policies,
    aws_sns_topic.topics
  ]
}