data "aws_iam_policy_document" "topic_policies" {
  for_each = { for topic in var.raw_sns_topics : topic.suffix => topic }

  dynamic "statement" {
    for_each = each.value["iam_policy_statements"]

    content {
      sid       = statement.value["sid"]
      actions   = statement.value["actions"]
      resources = statement.value["resources"]

      dynamic "principals" {
        for_each = statement.value["principals"]

        content {
          type        = principals.value["type"]
          identifiers = principals.value["identifiers"]
        }
      }

      dynamic "condition" {
        for_each = statement.value["conditions"]

        content {
          test     = condition.value["test"]
          variable = condition.value["variable"]
          values   = condition.value["values"]
        }
      }
    }
  }
}