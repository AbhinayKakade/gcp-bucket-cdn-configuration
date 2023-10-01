provider "google" {
  credentials = file("./key.json")
  version     = "3.5.0"
  region      = "us-central1"
  project     = var.gcp_project_id
}
 
provider "google-beta" {
  credentials = file("./key.json")
  version     = "3.5.0"
  region      = var.gcp_region
  project     = var.gcp_project_id
}
 