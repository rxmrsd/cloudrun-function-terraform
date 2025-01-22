resource "google_cloud_run_v2_service" "service" {
  name     = var.service_name
  location = var.region
  ingress = var.ingress

  template {
    containers {
      image = var.image

      ports {
        container_port = var.port
      }

      dynamic "env" {
        for_each = var.env_vars
        content {
          name  = env.key
          value = env.value
        }
      }
    }
    scaling {
      min_instance_count = var.min_instances
      max_instance_count = 100
    }
    service_account     = var.service_account

    dynamic "vpc_access" {
      for_each = var.network_name != null && var.subnet_name != null ? [1] : []
      content {
        network_interfaces {
          network    = var.network_name
          subnetwork = var.subnet_name
        }
        egress = "ALL_TRAFFIC"
      }
    }

    volumes {
      name = "cloudsql"
      cloud_sql_instance {
        instances = [var.cloudsql_instance]
      }
    }
  }
}