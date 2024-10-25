variable "project_id" {
  description = "GCP Project ID"
  type        = string
}
variable "region" {
  description = "GCP region"
  type        = string
  default     = "us-central1"   
}

variable "vm_instance_type" {
  description = "VM instance type"
  type        = string
  default     = "e2-small"
}

variable "zone" {
  description = "GCP zone for the VM"
  type        = string
  default     = "us-central1-a"
}

variable "vm_name" {
  description = "Name of the VM instance"
  type        = string
  default     = "aus-fuel-instance"
}

variable "disk_size" {
  description = "Boot disk size in GB"
  type        = number
  default     = 10
}

variable "tags" {
  description = "Network tags for the instance"
  type        = list(string)
  default     = ["server"]
}
variable "allowed_ip_ranges" {
  description = "List of IP ranges to allow access (CIDR notation)"
  type        = list(string)
  default     = ["0.0.0.0/0"]  
}

variable "service_account_email" {
    description = "The email of service account to use"
    type = string
  
}