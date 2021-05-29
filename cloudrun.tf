resource "google_cloud_run_service" "cloud_run_service" {
  name = "api"
  location = "europe-west2"

  template {
    spec {
      containers {
        image = "eu.gcr.io/stevenshipton-com/api:3ea9fe2"
      }
    }
  }  
}
