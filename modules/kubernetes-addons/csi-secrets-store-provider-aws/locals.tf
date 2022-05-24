locals {
  name = "csi-secrets-store-provider-aws"

  default_helm_config = {
    name        = local.name
    chart       = local.name
    repository  = "https://aws.github.io/eks-charts"
    version     = "0.0.2"
    namespace   = local.name
    description = "A Helm chart to install the Secrets Store CSI Driver and the AWS Key Management Service Provider inside a Kubernetes cluster."
    values      = []
    timeout     = "1200"
  }

  helm_config = merge(
    local.default_helm_config,
    var.helm_config
  )

  irsa_config = {
    create_kubernetes_namespace       = true
    kubernetes_namespace              = local.name
    create_kubernetes_service_account = false
    kubernetes_service_account        = local.name
  }
  
  argocd_gitops_config = {
    enable = true
  }
}