data "aws_iam_policy_document" "karpenter" {
  statement {
    sid       = "KarpenterControllerPolicy"
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "ec2:CreateFleet",
      "ec2:CreateLaunchTemplate",
      "ec2:CreateTags",
      "ec2:DeleteLaunchTemplate",
      "ec2:DescribeAvailabilityZones",
      "ec2:DescribeImages",
      "ec2:DescribeInstances",
      "ec2:DescribeInstanceTypeOfferings",
      "ec2:DescribeInstanceTypes",
      "ec2:DescribeLaunchTemplates",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeSpotPriceHistory",
      "ec2:DescribeSubnets",
      "ec2:RunInstances",
      "iam:PassRole",
      "pricing:GetProducts",
      "ssm:GetParameter",
    ]
  }

  statement {
    sid       = "KarpenterConditionalEC2Termination"
    effect    = "Allow"
    resources = ["*"]
    actions   = ["ec2:TerminateInstances"]

    condition {
      test     = "StringLike"
      variable = "ec2:ResourceTag/Name"
      values   = ["*karpenter*"]
    }
  }

  statement {
    sid       = "KarpenterEventPolicySQS"
    effect    = "Allow"
    resources = [local.karpenter_sqs_queue_arn]

    actions = [
      "sqs:DeleteMessage",
      "sqs:GetQueueAttributes",
      "sqs:GetQueueUrl",
      "sqs:ReceiveMessage",
    ]
  }
}
