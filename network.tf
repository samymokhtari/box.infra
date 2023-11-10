resource "google_compute_network" "vpc_network" {
  project                 = var.project_id
  name                    = var.vpc_name
  auto_create_subnetworks = false

  depends_on = [google_project_service.compute]
}


resource "google_compute_subnetwork" "subnet" {
  name          = "subnet-1"
  ip_cidr_range = var.public_ip_range
  region        = var.region
  network       = google_compute_network.vpc_network.id
  secondary_ip_range {
    range_name    = "private-ip-range"
    ip_cidr_range = var.private_ip_range
  }
}

resource "google_compute_subnetwork" "subnet-vpc-connector" {
  name          = "subnet-vpc-con"
  ip_cidr_range = var.vpc_connector_ip_range
  region        = var.region
  network       = google_compute_network.vpc_network.id
}

resource "google_vpc_access_connector" "connector" {
  name = "vpc-con"
  subnet {
    name = google_compute_subnetwork.subnet-vpc-connector.name
  }
  machine_type  = "e2-micro"
  min_instances = 2
  max_instances = 3
}


resource "google_compute_address" "static" {
  name         = "nat-public-ip"
  network_tier = "STANDARD"
  labels       = local.tags
  address_type = "EXTERNAL"
}

resource "google_compute_firewall" "default" {
  name    = "allow-sql-ssh"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["22", "3306", "1433"]
  }
  target_tags   = [var.compute_instance_name]
  source_ranges = ["0.0.0.0/0"]
}
  