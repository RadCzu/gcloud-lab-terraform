resource "google_service_account" "k8s_service_account" {
  account_id   = "k8s-sa"
  display_name = "Kubernetes Node Pool Service Account"
  project      = var.project
}

resource "google_project_iam_member" "k8s_sa_node_role" {
  project = var.project
  role    = "roles/container.nodeServiceAccount"
  member  = "serviceAccount:${google_service_account.k8s_service_account.email}"

  depends_on = [google_service_account.k8s_service_account]
}

resource "google_project_iam_member" "k8s_sa_log_writer" {
  project = var.project
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:${google_service_account.k8s_service_account.email}"

  depends_on = [google_service_account.k8s_service_account]
}

resource "google_project_iam_member" "k8s_sa_metric_writer" {
  project = var.project
  role    = "roles/monitoring.metricWriter"
  member  = "serviceAccount:${google_service_account.k8s_service_account.email}"

  depends_on = [google_service_account.k8s_service_account]
}

resource "google_container_cluster" "primary" {
  name     = "gloud-k8s-cluster"
  location = "us-central1"
  remove_default_node_pool = true
  initial_node_count       = 1
}

resource "google_container_node_pool" "primary_preemptible_nodes" {
  name       = "gloud-k8s-node-pool"
  location   = google_container_cluster.primary.location
  cluster    = google_container_cluster.primary.name
  node_count = 1

  node_config {
    preemptible  = true
    machine_type = "e2-medium"
    service_account = google_service_account.k8s_service_account.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}