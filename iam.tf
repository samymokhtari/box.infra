resource "google_service_account" "sa" {
  account_id   = "sac-${var.env}-box"
  display_name = "Box - Service Account"

  depends_on = [
    google_project_service.cloudresourcemanager,
    google_project_service.iam,
  ]
}

# Allow rights to SA
resource "google_service_account_iam_member" "gce-account-iam" {
  service_account_id = google_service_account.sa.name
  role               = "roles/iam.serviceAccountUser"
  member             = "serviceAccount:${google_service_account.sa.email}"
}

resource "google_storage_bucket_iam_member" "gce-storage" {
  bucket = google_storage_bucket.default.name
  role   = "roles/storage.admin"
  member = "serviceAccount:${google_service_account.sa.email}"
}

resource "google_artifact_registry_repository_iam_member" "member" {
  project    = google_artifact_registry_repository.this.project
  location   = google_artifact_registry_repository.this.location
  repository = google_artifact_registry_repository.this.name
  role       = "roles/artifactregistry.admin"
  member     = "serviceAccount:${google_service_account.sa.email}"
}

resource "google_compute_instance_iam_member" "gce-compute" {
  project = google_compute_instance.default.project
  zone = google_compute_instance.default.zone
  instance_name = google_compute_instance.default.name
  role = "roles/compute.osLogin"
  member = "serviceAccount:${google_service_account.sa.email}"
}