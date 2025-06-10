resource "google_service_account" "app_service_account" {
  account_id = "api-app-sa"
  display_name = "Custom SA for a single app.js Instance"
  project = var.project
}

resource "google_compute_instance" "default" {
  name         = "api-app-vm"
  machine_type = "n2-standard-2"
  zone         = "us-central1-a"
  
  tags = ["api-app"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
      labels = {
        app = "api-app"
      }
    }
  }

  scratch_disk {
    interface = "NVME"
  }

  network_interface {
    network = "default"

    access_config {
      # Ephemeral public IP — keep this so you can SSH and access the VM from the internet.
    }
  }

metadata = {
  docker_username = var.DOCKER_USERNAME
  docker_password = var.GITHUB_PAT
}

  metadata_startup_script = file("${path.module}/app-vm-startup.sh")

  service_account {
    email  = google_service_account.app_service_account.email
    scopes = ["cloud-platform"]
  }
}

resource "google_compute_firewall" "allow_2137" {
  name    = "allow-2137"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["2137"]
  }

  source_ranges = ["0.0.0.0/0"]
  direction     = "INGRESS"
  target_tags   = ["api-app"]
}
