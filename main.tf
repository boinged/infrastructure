provider "google" {
  version = "3.16.0"
}

provider "google-beta" {
  version = "3.16.0"
}

resource "google_container_cluster" "cluster" {
  name     = var.cluster
  location = var.location

  initial_node_count       = 1
  remove_default_node_pool = true

  logging_service    = "none"
  monitoring_service = "none"
  network            = "default"

  addons_config {
    http_load_balancing {
      disabled = "true"
    }
  }
}

resource "google_container_node_pool" "main_pool" {
  name     = "main"
  cluster  = google_container_cluster.cluster.name
  location = google_container_cluster.cluster.location

  node_count = 1

  management {
    auto_repair  = true
    auto_upgrade = false
  }

  node_config {
    disk_size_gb = "10"
    machine_type = "f1-micro"
    preemptible  = true

    oauth_scopes = [
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/monitoring.write"
    ]
  }
}

resource "google_container_node_pool" "ingress_pool" {
  name     = "ingress"
  cluster  = google_container_cluster.cluster.name
  location = google_container_cluster.cluster.location

  node_count = 1

  management {
    auto_repair  = true
    auto_upgrade = false
  }

  node_config {
    disk_size_gb = "10"
    machine_type = "f1-micro"
    preemptible  = true
    tags         = ["ingress"]

    oauth_scopes = [
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/monitoring.write"
    ]
  }
}

provider "kubernetes" {
  version = "1.11.1"
  host    = google_container_cluster.cluster.endpoint

  client_certificate     = base64decode(google_container_cluster.cluster.master_auth.0.client_certificate)
  client_key             = base64decode(google_container_cluster.cluster.master_auth.0.client_key)
  cluster_ca_certificate = base64decode(google_container_cluster.cluster.master_auth.0.cluster_ca_certificate)
}
