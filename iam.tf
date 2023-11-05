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