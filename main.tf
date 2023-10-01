
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
# CREATE A GOOGLE COMPUTE MANAGED CERTIFICATE
# ------------------------------------------------------------------------------
resource "google_compute_managed_ssl_certificate" "cdn_certificate" {
  provider = google-beta
  project  = var.gcp_project_id
 
  name = "cdn-managed-certificate"
 
  managed {
    domains = [local.cdn_domain]
  }
}
 
# ------------------------------------------------------------------------------
# CREATE HTTPS PROXY
# ------------------------------------------------------------------------------
 
resource "google_compute_target_https_proxy" "cdn_https_proxy" {
  name             = "cdn-https-proxy"
  url_map          = google_compute_url_map.cdn_url_map.self_link
  ssl_certificates = [google_compute_managed_ssl_certificate.cdn_certificate.self_link]
  project          = var.gcp_project_id
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
# CREATE A GLOBAL FORWARDING RULE
# ------------------------------------------------------------------------------
 
resource "google_compute_global_forwarding_rule" "cdn_global_forwarding_rule" {
  name       = "poc-test-cdn-global-forwarding-https-rule"
  target     = google_compute_target_https_proxy.cdn_https_proxy.self_link
  ip_address = google_compute_global_address.cdn_public_address.address
  port_range = "443"
  project    = var.gcp_project_id
}

# ------------------------------------------------------------------------------
# CREATE DNS RECORD
# ------------------------------------------------------------------------------
 
# resource "google_dns_record_set" "cdn_dns_a_record" {
#   managed_zone = var.managed_zone # Name of your managed DNS zone
#   name         = "${local.cdn_domain}."
#   type         = "A"
#   ttl          = 3600 # 1 hour
#   rrdatas      = [google_compute_global_address.cdn_public_address.address]
#   project      = "poc-test-poc"
# }

# ------------------------------------------------------------------------------
# MAKE THE BUCKET PUBLIC
# ------------------------------------------------------------------------------
 
resource "google_storage_bucket_iam_member" "all_users_viewers" {
  bucket = google_storage_bucket.cdn_bucket.name
  role   = "roles/storage.legacyObjectReader"
  member = "allUsers"
}