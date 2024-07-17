provider "google" {
  project = "idme-demo-429222"
  credentials = file("terraform/credentials.json")
  region  = var.region
}

resource "google_container_cluster" "primary" {
  name     = "hello-world-cluster"
  location = var.region

  initial_node_count = 1
}

resource "google_container_node_pool" "primary_preemptible_nodes" {
  name       = "primary-preemptible-nodes"
  location   = var.region
  cluster    = google_container_cluster.primary.name

  node_config {
    preemptible  = true
    machine_type = "e2-micro"

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }

  initial_node_count = 1
}

resource "google_container_node_pool" "primary_nodes" {
  name       = "primary-nodes"
  location   = var.region
  cluster    = google_container_cluster.primary.name

  node_config {
    machine_type = "e2-micro"

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }

  initial_node_count = 1
}

output "kubernetes_cluster_name" {
  value = google_container_cluster.primary.name
}

output "region" {
  value = var.region
}
