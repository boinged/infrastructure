resource "google_cloudbuild_trigger" "ci_trigger" {
  provider = google-beta
  name     = "web-ci"

  github {
    owner = "boinged"
    name  = "web-app"

    push {
      branch = "master"
    }
  }

  filename = "cloudbuild.yaml"
}

resource "google_cloudbuild_trigger" "cd_trigger" {
  provider = google-beta
  name     = "web-cd"

  github {
    owner = "boinged"
    name  = "web-env"

    push {
      branch = "master"
    }
  }

  substitutions = {
    _CLUSTER  = var.cluster
    _LOCATION = var.location
  }

  filename = "cloudbuild.yaml"
}
