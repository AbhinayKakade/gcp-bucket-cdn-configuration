
# ------------------------------------------------------------------------------
# CREATE A STORAGE BUCKET
# ------------------------------------------------------------------------------
 
resource "google_storage_bucket" "cdn_bucket" {
  name          = "poc-test-cdn-bucket"
  storage_class = "MULTI_REGIONAL"
  location      = "EU" # You might pass this as a variable
  project       = var.gcp_project_id
}
 
# ------------------------------------------------------------------------------
# CREATE A BACKEND CDN BUCKET
# ------------------------------------------------------------------------------
 
resource "google_compute_backend_bucket" "cdn_backend_bucket" {
  name        = "da-poc-test-backend-bucket"
  description = "Backend bucket for serving static content through CDN"
  bucket_name = google_storage_bucket.cdn_bucket.name
  enable_cdn  = true
  project     = var.gcp_project_id
}

# ------------------------------------------------------------------------------
# CREATE A URL MAP
# ------------------------------------------------------------------------------
 
resource "google_compute_url_map" "cdn_url_map" {
  name            = "cdn-url-map"
  description     = "CDN URL map to cdn_backend_bucket"
  default_service = google_compute_backend_bucket.cdn_backend_bucket.self_link
  project         = var.gcp_project_id
}

# ------------------------------------------------------------------------------
# CREATE A GLOBAL PUBLIC IP ADDRESS
# ------------------------------------------------------------------------------
 
resource "google_compute_global_address" "cdn_public_address" {
  name         = "poc-test-cdn-public-address"
  ip_version   = "IPV4"
  address_type = "EXTERNAL"
  project      = var.gcp_project_id
}
 
# ------------------------------------------------------------------------------
# MAKE THE BUCKET PUBLIC
# ------------------------------------------------------------------------------
 
resource "google_storage_bucket_iam_member" "all_users_viewers" {
  bucket = google_storage_bucket.cdn_bucket.name
  role   = "roles/storage.legacyObjectReader"
  member = "allUsers"
}