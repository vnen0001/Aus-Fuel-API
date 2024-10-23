provider "google" {
    credentials = file("terrafrom-gcp-cred.json")
    project = var.project_id
    region =  var.region
  
}
