resource "google_cloudbuild_trigger" "trigger" {
  name        = var.name
  location    = var.location
  description = "${var.name} build trigger"

  github {
    name  = var.repo_name
    owner = var.repo_owner

    push {
      branch       = "^${var.branch_name}$"
      invert_regex = false
    }
  }

  substitutions = var.substitutions

  filename = var.build_file_name
  service_account = "projects/${var.project_id}/serviceAccounts/${var.service_account_name}@${var.project_id}.iam.gserviceaccount.com"

}