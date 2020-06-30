resource "google_bigquery_dataset" "default" {
  dataset_id  = "nginx_logs"
  description = "NGINX Access Logs"
  location    = "US"
}

resource "google_logging_project_sink" "nginx" {
  name                   = "nginx-logs-gke"
  destination            = "bigquery.googleapis.com/projects/${var.project}/datasets/${google_bigquery_dataset.default.dataset_id}"
  filter                 = "resource.type=k8s_container AND resource.labels.cluster_name=tmux-test AND resource.labels.namespace_name=ozrlz"
  unique_writer_identity = true
}

resource "google_logging_project_sink" "flask" {
  name                   = "flask-logs-gke"
  destination            = "bigquery.googleapis.com/projects/${var.project}/datasets/${google_bigquery_dataset.default.dataset_id}"
  filter                 = "resource.type=k8s_container AND resource.labels.cluster_name=tmux-test AND resource.labels.namespace_name=ozrlz-2"
  unique_writer_identity = true
}

resource "google_project_iam_binding" "default" {
  role = "roles/bigquery.dataEditor"

  members = [
    google_logging_project_sink.nginx.writer_identity,
    google_logging_project_sink.flask.writer_identity,
  ]
}

