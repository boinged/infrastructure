resource "kubernetes_deployment" "kube-dns-autoscaler-deployment" {
  metadata {
    namespace = "kube-system"
  }

  spec {
    replicas = 0
  }
}
