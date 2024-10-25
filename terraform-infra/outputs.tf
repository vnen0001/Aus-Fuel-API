output "vm_public_ip_output" {
    description = "Displays the IP of VM created"
    value = google_compute_instance.aus_fuel_hosting_demo.network_interface[0].access_config[0].nat_ip
  
}

output "vm_name" {
    description = "The name of the VM created" 
    value = google_compute_instance.aus_fuel_hosting_demo.hostname
  
}