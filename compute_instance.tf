resource "google_compute_instance" "default" {
  name                      = var.compute_instance_name
  machine_type              = "f1-micro"
  zone                      = "${var.region}-b"
  description               = "Instance for ${var.env} environment"
  hostname                  = var.compute_instance_name
  allow_stopping_for_update = true

  tags = values(local.tags)

  boot_disk {
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
    network = google_compute_network.vpc_network.id
    alias_ip_range {
      ip_cidr_range = var.ip_vm_sql
    }
  }

  service_account {
    email = google_service_account.sa.email
    scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
      "https://www.googleapis.com/auth/sqlservice.admin"
    ]
  }


  metadata_startup_script = "sudo apt-get update -y && sudo apt-get upgrade -y"

  depends_on = [
    google_project_service.compute
  ]
}