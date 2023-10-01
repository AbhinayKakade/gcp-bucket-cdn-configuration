module "cdn" {
  source = "../../modules/cdn"
  gcp_region          = var.gcp_region
}