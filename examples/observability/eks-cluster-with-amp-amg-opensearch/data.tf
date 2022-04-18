data "aws_iam_policy_document" "fluentbit-opensearch-access" {
  statement {
    sid       = "OpenSearchAccess"
    effect    = "Allow"
    resources = ["${aws_elasticsearch_domain.opensearch.arn}/*"]
    actions   = ["es:ESHttp*"]
  }
}

data "aws_iam_policy_document" "opensearch_access_policy" {
  statement {
    effect    = "Allow"
    resources = ["${aws_elasticsearch_domain.opensearch.arn}/*"]
    actions   = ["es:ESHttp*"]
    principals {
      type        = "*"
      identifiers = ["*"]
    }
  }
}

data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

data "aws_elasticsearch_domain" "opensearch" {
  domain_name = aws_elasticsearch_domain.opensearch.domain_name
}
