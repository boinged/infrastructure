data "google_client_config" "current" {
}

resource "google_storage_bucket" "state_bucket" {
  name     = "${data.google_client_config.current.project}-tfstate"
  location = "EUROPE-WEST2"
}
