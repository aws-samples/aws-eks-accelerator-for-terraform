locals {
  name                 = "aws-cloudwatch-metrics"
  namespace            = "amazon-cloudwatch"
  service_account_name = "cloudwatch-agent"

  set_values = [
    {
      name  = "serviceAccount.name"
      value = local.service_account_name
    },
    {
      name  = "serviceAccount.create"
      value = false
    }
  ]

  default_helm_config = {
    name        = local.name
    chart       = local.name
    repository  = "https://aws.github.io/eks-charts"
    version     = "0.0.7"
    namespace   = local.namespace
    values      = local.default_helm_values
    description = "aws-cloudwatch-metrics Helm Chart deployment configuration"
  }

  helm_config = merge(
    local.default_helm_config,
    var.helm_config
  )

  default_helm_values = []

  argocd_gitops_config = {
    enable             = true
    serviceAccountName = local.service_account_name
  }

  irsa_config = {
    kubernetes_namespace              = local.helm_config["namespace"]
    kubernetes_service_account        = local.service_account_name
    create_kubernetes_namespace       = true
    create_kubernetes_service_account = true
    irsa_iam_policies                 = concat(["arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"], var.irsa_policies)
  }
}
