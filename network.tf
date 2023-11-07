resource "google_compute_network" "vpc_network" {
  project                 = var.project_id
  name                    = var.vpc_name
  auto_create_subnetworks = true

  depends_on = [google_project_service.compute]
}

resource "google_vpc_access_connector" "connector" {
  name          = "vpc-con"
  ip_cidr_range = var.ip_cidr_range
  network       = google_compute_network.vpc_network.self_link
  machine_type  = "e2-micro"
}