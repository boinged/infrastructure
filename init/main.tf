data "google_client_config" "current" {
}

resource "google_storage_bucket" "state_bucket" {
  name     = "${data.google_client_config.current.project}-tfstate"
  location = "EUROPE-WEST2"

  uniform_bucket_level_access = true

  versioning {
    enabled = true
  }

  lifecycle_rule {
    condition {
      num_newer_versions = 3
    }

    action {
      type = "Delete"
    }
  }
}
