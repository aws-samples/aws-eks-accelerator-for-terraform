locals {
  name                 = "argo-rollouts"

  default_helm_config = {
    name        = local.name
    chart       = local.name
    repository  = "https://argoproj.github.io/argo-helm"
    version     = "2.9.1"
    namespace   = local.name
    description = "Argo Rollouts AddOn Helm Chart"
    values      = null
    timeout     = "1200"
  }

  helm_config = merge(
    local.default_helm_config,
    var.helm_config
  )

  argocd_gitops_config = {
    enable             = true
  }
}
