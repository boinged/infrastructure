provider "google" {
  version = "3.27.0"
}

provider "google-beta" {
  version = "3.27.0"
}

provider "kubernetes" {
  version = "1.11.3"
  host    = google_container_cluster.cluster.endpoint

  client_certificate     = base64decode(google_container_cluster.cluster.master_auth.0.client_certificate)
  client_key             = base64decode(google_container_cluster.cluster.master_auth.0.client_key)
  cluster_ca_certificate = base64decode(google_container_cluster.cluster.master_auth.0.cluster_ca_certificate)
}
