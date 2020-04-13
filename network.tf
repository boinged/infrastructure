resource "google_compute_address" "ip_address" {
  provider = google-beta
  name     = "kubeip-ip1"
  region   = var.region

  labels = {
    kubeip = "reserved"
  }
}

resource "google_compute_firewall" "firewall" {
  name    = "gke-${var.cluster}-web"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = google_container_node_pool.ingress_pool.node_config[0].tags
}