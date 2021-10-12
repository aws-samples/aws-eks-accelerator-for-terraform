
locals {
  default_metric_server_helm_app = {
    name                       = "metrics-server"
    chart                      = "metrics-server"
    repository                 = "https://charts.bitnami.com/bitnami"
    version                    = "5.10.1"
    namespace                  = "kube-system"
    timeout                    = "1200"
    create_namespace           = false
    values                     = null
    set                        = null
    set_sensitive              = null
    lint                       = false
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
    wait                       = true
    wait_for_jobs              = false
    dependency_update          = false
    replace                    = false
    description                = "Metric server helm Chart deployment configuration"
    postrender                 = ""
  }
  metric_server_helm_app = merge(
    local.default_metric_server_helm_app,
    var.metrics_server_helm_chart
  )
}
