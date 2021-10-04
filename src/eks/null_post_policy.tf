resource "null_resource" "post-policy" {
  depends_on = [aws_iam_policy.load-balancer-policy]

  triggers = {
    always_run = timestamp()
  }

  provisioner "local-exec" {
    on_failure = fail
    # interpreter = ["/bin/bash", "-c"]
    when    = create
    command = <<EOT
            reg=$(echo ${aws_eks_cluster.example.arn} | cut -f4 -d':')
            acc=$(echo ${aws_eks_cluster.example.arn} | cut -f5 -d':')
            cn=$(echo ${aws_eks_cluster.example.name})
            echo "$reg $cn $acc"
            ${path.module}/post-policy.sh $reg $cn $acc
            echo "done"
        EOT
  }
}
