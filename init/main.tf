data "google_client_config" "current" {
}

resource "google_storage_bucket" "bucket" {
  name     = "${data.google_client_config.current.project}-tfstate"
  location = var.region

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

#resource "google_storage_bucket_acl" "bucket_acl" {
#  bucket = "${google_storage_bucket.bucket.name}"
#
#  role_entity = [
#    "OWNER:${var.user}"
#  ]
#}
