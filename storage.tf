resource "google_storage_bucket" "default" {
  name          = var.bucket_storage
  location      = var.region
  force_destroy = true

  public_access_prevention = "enforced"
}
