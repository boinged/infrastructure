resource "google_app_engine_application" "app" {
  location_id = var.region
}
resource "google_app_engine_domain_mapping" "domain_mapping" {
  domain_name = var.domain

  ssl_settings {
    ssl_management_type = "AUTOMATIC"
  }
}
