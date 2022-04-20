variable "vmware_username" {
  description = "vSphere username"
  type        = string
  sensitive   = true
}

variable "vmware_password" {
  description = "vSphere Password"
  type        = string
  sensitive   = true
}

variable "vm_name" {
  description = "New VM Name"
  type	      = string
  default     = "0_Terraform_Admin01"
}
