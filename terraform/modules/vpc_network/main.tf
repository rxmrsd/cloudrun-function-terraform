resource "google_compute_network" "custom_network" {
  name       = var.network_name
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "custom_subnet" {
  name          = var.subnet_name
  network       = google_compute_network.custom_network.id
  region        = var.region
  ip_cidr_range = var.ip_range

  private_ip_google_access = true
}

output "network_id" {
  value = google_compute_network.custom_network.id
}