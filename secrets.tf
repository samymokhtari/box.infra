resource "google_secret_manager_secret" "secret-gcp" {
  secret_id = "GCP_CREDENTIALS"

  replication {
    user_managed {
      replicas {
        location = var.region
      }
    }
  }

  depends_on = [
    google_project_service.secret
  ]
}

resource "google_secret_manager_secret" "secret-connstr" {
  secret_id = "CONN_STR"

  replication {
    user_managed {
      replicas {
        location = var.region
      }
    }
  }

  depends_on = [
    google_project_service.secret
  ]
}

resource "google_secret_manager_secret_version" "secret-version-gcp" {
  secret = google_secret_manager_secret.secret-gcp.id

  secret_data = var.gcp_credentials
}

resource "google_secret_manager_secret_version" "secret-version-connstr" {
  secret = google_secret_manager_secret.secret-connstr.id

  secret_data = var.conn_str_sql
}