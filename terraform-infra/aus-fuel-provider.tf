provider "google" {
    credentials = file("terraform-gcp-cred.json")
    project = var.project_id
    region =  var.region
    zone = var.zone
  
}
