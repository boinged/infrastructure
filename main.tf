terraform {
  backend "gcs" {
    prefix = "env/prod"
  }
}

resource "google_project_service" "project" {
  for_each = toset(var.services)
  service  = each.value

  disable_dependent_services = true
}
