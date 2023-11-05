resource "google_storage_bucket" "default" {
  name          = var.bucket_storage
  location      = var.region
  force_destroy = true

  public_access_prevention = "enforced"
}

resource "google_artifact_registry_repository" "this" {
  location      = var.region
  repository_id = "${var.env}-box"
  description   = "Box Artifact Registry"
  format        = "DOCKER"

  cleanup_policies {
    id     = "keep-minimum-versions"
    action = "KEEP"
    most_recent_versions {
      package_name_prefixes = [var.env]
      keep_count            = 3
    }
  }

  depends_on = [
    google_project_service.artifactregistry,
  ]
}
