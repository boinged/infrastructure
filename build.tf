resource "google_cloudbuild_trigger" "api_ci_trigger" {
  provider = google-beta
  name     = "api-ci"

  github {
    owner = "boinged"
    name  = "api-app"

    push {
      branch = "master"
    }
  }

  filename = "cloudbuild.yaml"
}

resource "google_cloudbuild_trigger" "api_cd_trigger" {
  provider = google-beta
  name     = "api-cd"

  github {
    owner = "boinged"
    name  = "api-env"

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

resource "google_cloudbuild_trigger" "web_cd_trigger" {
  provider = google-beta
  name     = "web-cd"

  github {
    owner = "boinged"
    name  = "web-app"

    push {
      branch = "master"
    }
  }

  substitutions = {
    _SERVICE_URL = google_compute_address.ip_address.address
  }

  filename = "cloudbuild.yaml"
}