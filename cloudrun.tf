resource "google_cloud_run_service" "run_service" {
  name     = "api"
  location = var.region

  template {
    spec {
      containers {
        image = "eu.gcr.io/stevenshipton-com/api:69906bc"

        env {
          name  = "DATABASE_URI"
          value = var.database_uri
        }
      }
    }
  }
}

resource "google_cloud_run_service_iam_member" "cloud_run_iam" {
  service  = google_cloud_run_service.run_service.name
  location = google_cloud_run_service.run_service.location
  role     = "roles/run.invoker"
  member   = "allUsers"
}
