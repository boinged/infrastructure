resource "google_cloudbuild_trigger" "api_ci_trigger" {
  name = "api-ci"

  github {
    owner = "boinged"
    name  = "api-app"

    push {
      branch = "main"
    }
  }

  filename = "cloudbuild.yaml"
}

resource "google_cloudbuild_trigger" "web_cd_trigger" {
  name = "web-cd"

  github {
    owner = "boinged"
    name  = "web-app"

    push {
      branch = "main"
    }
  }

  substitutions = {
    _SERVICE_IP = "127.0.0.1"
  }

  filename = "cloudbuild.yaml"
}
