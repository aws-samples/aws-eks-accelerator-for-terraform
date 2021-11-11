/*
 * Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
 * SPDX-License-Identifier: MIT-0
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of this
 * software and associated documentation files (the "Software"), to deal in the Software
 * without restriction, including without limitation the rights to use, copy, modify,
 * merge, publish, distribute, sublicense, and/or sell copies of the Software, and to
 * permit persons to whom the Software is furnished to do so.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
 * INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
 * PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 * HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
 * OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
 * SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

locals {
  default_aws_node_termination_handler_helm_app = {
    name        = "aws-node-termination-handler"
    chart       = "aws-node-termination-handler"
    repository  = "https://aws.github.io/eks-charts"
    version     = "0.16.0"
    namespace   = "kube-system"
    timeout     = "1200"
    values      = [templatefile("${path.module}/aws-node-termination-handler-values.yaml", {})]
    verify      = false
    description = "The AWS Node Termination Handler Helm Chart deployment configuration"
  }
  aws_node_termination_handler_helm_app = merge(
    local.default_aws_node_termination_handler_helm_app,
    var.aws_node_termination_handler_helm_chart
  )
}