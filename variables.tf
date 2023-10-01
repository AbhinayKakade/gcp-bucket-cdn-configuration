# Variables for GCS bucket
variable "gcs_bucket_name" {
  description = "Name of the Google Cloud Storage bucket"
  type        = string
  default     = "your-cdn-bucket-name"
}

variable "region" {
  description = "Region for the GCS bucket"
  type        = string
  default     = "us-central1"
}

# Variables for CDN
variable "cdn_secret_key" {
  description = "Secret key for CDN configuration"
  type        = string
  default     = "your-secret-key"
}

variable "cdn_backend_name" {
  description = "Name for the CDN backend bucket"
  type        = string
  default     = "cdn-backend"
}

variable "cdn_url_map_name" {
  description = "Name for the CDN URL map"
  type        = string
  default     = "cdn-url-map"
}

variable "cdn_forwarding_rule_name" {
  description = "Name for the CDN forwarding rule"
  type        = string
  default     = "cdn-forwarding-rule"
}

variable "projet"{
    description = "s"
}
