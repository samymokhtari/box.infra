resource "google_compute_instance" "default" {
  name                      = var.compute_instance_name
  machine_type              = "e2-micro"
  zone                      = "${var.region}-b"
  description               = "Instance for ${var.env} environment"
  hostname                  = "${var.compute_instance_name}.${var.env}.internal"
  allow_stopping_for_update = true

  tags = [var.env, var.compute_instance_name]

  boot_disk {
    auto_delete = false
    initialize_params {
      image = "debian-cloud/debian-11"
      labels = {
        target = "database"
        env    = var.env
      }
    }
  }

  metadata = {
    ssh-keys = "${var.ssh_user}:${var.ssh_public_key}"
  }

  network_interface {
    subnetwork = google_compute_subnetwork.subnet.self_link
    access_config {
      nat_ip       = google_compute_address.static.address
      network_tier = "STANDARD"
    }
  }

  service_account {
    email = google_service_account.sa.email
    scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
      "https://www.googleapis.com/auth/sqlservice.admin"
    ]
  }

  depends_on = [
    google_project_service.compute
  ]
}