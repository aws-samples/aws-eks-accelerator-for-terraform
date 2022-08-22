locals {
  name = "datadog-operator"

  default_helm_config = {
    name        = local.name
    chart       = local.name
    repository  = "https://helm.datadoghq.com"
    version     = "0.8.6"
    namespace   = local.name
    description = "The Datadog Operator Helm chart default configuration"
    values      = null
    timeout     = "1200"
  }

  helm_config = merge(
    local.default_helm_config,
    var.helm_config
  )

  argocd_gitops_config = {
    enable = true
  }
}
