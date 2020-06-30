provider "google" {
  credentials = file(var.credential_path)
  project     = var.project
}