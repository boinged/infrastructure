resource "google_service_account" "kubeip_service_account" {
  account_id   = "kubeip-service-account"
  display_name = "kubeIP"
}

resource "google_project_iam_custom_role" "kubeip_role" {
  role_id     = "kubeip"
  title       = "kubeip"
  description = "required permissions to run KubeIP"
  permissions = [
    "compute.addresses.list",
    "compute.instances.addAccessConfig",
    "compute.instances.deleteAccessConfig",
    "compute.instances.get",
    "compute.instances.list",
    "compute.projects.get",
    "container.clusters.get",
    "container.clusters.list",
    "resourcemanager.projects.get",
    "compute.networks.useExternalIp",
    "compute.subnetworks.useExternalIp",
    "compute.addresses.use"
  ]
}

resource "google_project_iam_member" "kubeip_binding" {
  role   = "projects/${var.project}/roles/${google_project_iam_custom_role.kubeip_role.role_id}"
  member = "serviceAccount:${google_service_account.kubeip_service_account.account_id}@${var.project}.iam.gserviceaccount.com"
}

resource "google_service_account_key" "kubeip_key" {
  service_account_id = google_service_account.kubeip_service_account.account_id
}

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