resource "aws_sns_topic" "topics" {
  for_each = { for topic in var.raw_sns_topics : topic.suffix => topic }

  name = format(lower("aws-${var.environment}-${var.application_name}-%s"), each.value["suffix"])
}