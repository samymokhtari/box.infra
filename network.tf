resource "google_compute_network" "vpc_network" {
  project                 = var.project_id
  name                    = var.vpc_name
  auto_create_subnetworks = false

  depends_on = [google_project_service.compute]
}

resource "google_compute_subnetwork" "private_subnet" {
  name          = "vpc-con"
  ip_cidr_range = var.private_subnet_cidr
  region        = var.region
  network       = google_compute_network.vpc_network.id
  purpose       = "PRIVATE_NAT"
}

resource "google_vpc_access_connector" "connector" {
  name = "vpc-con"
  subnet {
    name = google_compute_subnetwork.private_subnet.name
  }
  machine_type = "e2-micro"
}