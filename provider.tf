provider "google" {
  credentials = file("./key.json")
  version     = "3.5.0"
  region      = "us-central1"
  project     = "poc-test-poc"
}
 
provider "google-beta" {
  credentials = file("./key.json")
  version     = "3.5.0"
  region      = "us-central1"
  project     = "poc-test-poc"
}
 
locals {
  cdn_domain = "exampledomain.com" # Change this to your domain. You’ll be able to access CDN on this hostname.
}