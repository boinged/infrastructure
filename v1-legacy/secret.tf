resource "kubernetes_secret" "kubeip_secret" {
  depends_on = [google_container_cluster.cluster]

  metadata {
    name      = "kubeip-key"
    namespace = "kube-system"
  }

  data = {
    "key.json" = base64decode(google_service_account_key.kubeip_key.private_key)
  }

  provisioner "local-exec" {
    command = <<EOT
      kubectl scale --replicas=0 deployment/kube-dns-autoscaler --namespace=kube-system
      kubectl scale --replicas=1 deployment/kube-dns --namespace=kube-system
      kubectl scale --replicas=0 deployment/metrics-server-v0.3.1 --namespace=kube-system
    EOT
  }
}

resource "kubernetes_secret" "database_secret" {
  depends_on = [google_container_cluster.cluster]

  metadata {
    name = "database"
  }

  data = {
    uri = var.database_uri
  }
}
