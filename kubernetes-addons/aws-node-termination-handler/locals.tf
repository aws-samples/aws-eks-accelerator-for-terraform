locals {
  queue_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = ["events.amazonaws.com", "sqs.amazonaws.com"]
      }
      Action = "sqs:SendMessage"
      Resource = [
        aws_sqs_queue.aws_node_termination_handler_queue.arn
      ]
    }]
  })

  namespace = "kube-system"

  service_account_name = "aws-node-termination-handler-sa"

  event_rules = [
    {
      name          = "NTHASGTermRule",
      event_pattern = <<EOF
{"source":["aws.autoscaling"],"detail-type":["EC2 Instance-terminate Lifecycle Action"]}
EOF
    },
    {
      name          = "NTHSpotTermRule",
      event_pattern = <<EOF
{"source": ["aws.ec2"],"detail-type": ["EC2 Spot Instance Interruption Warning"]}
EOF
    },
    {
      name          = "NTHRebalanceRule",
      event_pattern = <<EOF
{"source": ["aws.ec2"],"detail-type": ["EC2 Instance Rebalance Recommendation"]}
EOF
    },
    {
      name          = "NTHInstanceStateChangeRule",
      event_pattern = <<EOF
{"source": ["aws.ec2"],"detail-type": ["EC2 Instance State-change Notification"]}
EOF
    },
    {
      name          = "NTHScheduledChangeRule",
      event_pattern = <<EOF
{"source": ["aws.health"],"detail-type": ["AWS Health Event"]}
EOF
    }
  ]

  irsa_policy = <<EOT
  {
    "Version": "2012-10-17",
    "Statement": [{
      "Effect": "Allow",
      "Resource": "*",

      "Actions": [
        "autoscaling:CompleteLifecycleAction",
        "autoscaling:DescribeAutoScalingInstances",
        "autoscaling:DescribeTags",
        "ec2:DescribeInstances",
        "sqs:DeleteMessage",
        "sqs:ReceiveMessage"
      ]
    }]
  }
EOT

  default_nth_helm_app = {
    name                       = "aws-node-termination-handler"
    chart                      = "aws-node-termination-handler"
    repository                 = "https://aws.github.io/eks-charts"
    version                    = "0.16.0"
    namespace                  = local.namespace
    timeout                    = "1200"
    create_namespace           = false
    description                = "AWS Node Termination Handler Helm Chart"
    lint                       = false
    wait                       = true
    wait_for_jobs              = false
    verify                     = false
    keyring                    = ""
    repository_key_file        = ""
    repository_cert_file       = ""
    repository_ca_file         = ""
    repository_username        = ""
    repository_password        = ""
    disable_webhooks           = false
    reuse_values               = false
    reset_values               = false
    force_update               = false
    recreate_pods              = false
    cleanup_on_fail            = false
    max_history                = 0
    atomic                     = false
    skip_crds                  = false
    render_subchart_notes      = true
    disable_openapi_validation = false
    dependency_update          = false
    replace                    = false
    postrender                 = ""
    set                        = []
    set_sensitive              = []
    values                     = local.default_nth_helm_values
  }

  aws_node_termination_handler_helm_app = merge(
    local.default_nth_helm_app,
    var.aws_node_termination_handler_helm_chart
  )

  default_nth_helm_values = [templatefile("${path.module}/aws-node-termination-handler-values.yaml", {
    nth-sa-name = local.service_account_name
  })]
}