resource "google_cloudbuild_trigger" "ci_trigger" {
  provider = google-beta
  name     = "website-ci"

  github {
    owner = "boinged"
    name  = "website"

    push {
      branch = "master"
    }
  }

  filename = "cloudbuild.yaml"
}