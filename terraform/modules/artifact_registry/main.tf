resource "google_artifact_registry_repository" "docker_repo" {
  provider           = google-beta
  project            = var.project_id
  location           = var.location
  repository_id      = var.repository_name
  format             = "DOCKER"
  description        = "Repository for ${var.repository_name}"
}