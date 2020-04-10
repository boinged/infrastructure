resource "google_compute_address" "ip_address" {
  provider = google-beta
  name = "kubeip-ip1"
  region = var.region

  labels = {
    kubeip = "reserved"
  }
}