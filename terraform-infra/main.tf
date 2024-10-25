
resource "google_compute_instance" "aus_fuel_hosting_demo" {
 name = var.vm_name
 machine_type = var.vm_instance_type
 zone = var.zone

boot_disk {
  initialize_params {
    image = "ubuntu-os-cloud/ubuntu-2204-lts"
    size = var.disk_size
    type = "pd-standard"
  }
  mode = "READ_WRITE"
}
network_interface {
  network = "default"
  access_config {
    network_tier = "STANDARD"
    
  }
  queue_count = 0
  stack_type = "IPV4_ONLY"
  subnetwork = "projects/${var.project_id}/regions${split("-", var.zone)[0]}/subnetworks/default"
}
scheduling {
  automatic_restart = true
  on_host_maintenance = "MIGRATE"
  preemptible = false 
  provisioning_model = "STANDARD"
}

shielded_instance_config {
  enable_integrity_monitoring = true
  enable_secure_boot = false
  enable_vtpm = true
}
service_account {
  email = var.service_account_email
  scopes =["https://www.googleapis.com/auth/devstorage.read_only", "https://www.googleapis.com/auth/logging.write", "https://www.googleapis.com/auth/monitoring.write", "https://www.googleapis.com/auth/service.management.readonly", "https://www.googleapis.com/auth/servicecontrol", "https://www.googleapis.com/auth/trace.append"]
}


tags = var.tags
}

resource "google_compute_firewall" "firewall_rule_for_vm" {
    name = "allowed-rules"
    network = "default"
    
    allow {
      protocol = "tcp"
      ports = ["80"]
    }
    allow {
      protocol = "tcp"
      ports = ["443"]
    }
    allow{
        protocol = "tcp"
        ports = ["22"]

    }
    source_ranges = var.allowed_ip_ranges
    source_tags = var.tags


}

