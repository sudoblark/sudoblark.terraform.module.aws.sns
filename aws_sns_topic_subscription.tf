locals {
  actual_subscriptions = flatten([
    for topic in var.raw_sns_topics : [
      for subscription in topic.subscriptions : merge(subscription, {
        topic_arn = aws_sns_topic.topics[topic.suffix].arn,
        identifier : format("%s/%s", topic.suffix, subscription.name)
      })
    ]
  ])
}


resource "aws_sns_topic_subscription" "subscriptions" {
  for_each = { for subscription in local.actual_subscriptions : subscription.identifier => subscription }

  topic_arn = each.value["topic_arn"]
  protocol  = each.value["protocol"]
  endpoint  = each.value["endpoint"]

  depends_on = [
    aws_sns_topic.topics
  ]
}