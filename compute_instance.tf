resource "google_compute_instance" "default" {
  name         = var.compute_instance_name
  machine_type = "f1-micro"
  zone         = "${var.region}-b"

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
    network = google_compute_network.vpc_network.name
  }

  metadata_startup_script = "sudo apt-get update -y && sudo apt-get upgrade -y && sudo echo ${var.ssh_public_key} >> ~/.ssh/authorized_keys"
}