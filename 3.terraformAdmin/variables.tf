variable "vm_name" {
  description = "New VM Name"
  type	      = string
  default     = "0_TerraformTest_Admin01"
}

variable "os_name" {
  description = "OS Hostname"
  type        = string
  default     = "test-admin01"
}

variable "cust_domain_admin_user" {
  description = "Domain admin user account"
  type        = string
  default     = "Administrator"
}

variable "cust_domain" {
  description = "Customer Domain Name"
  type        = string
  default     = "test.lab"
}


variable "cust_vlan" {
  description = "Customer VLAN number for deployment"
  type        = string
  default     = 99
}

variable "vm_datastore" {
  description = "Datastore name where VM will be deployed"
  type        = string
  default     = "DC3vSANDatastore03"
}

variable "vm_cluster" {
  description = "Cluster VM will be deployed to"
  type        = string
  default     = "DC3-VSAN3-81009"
}

variable "vm_network"{
  description = "NIC network to assign to VMs"
  type        = string
  default     = "pg999Isolated_DC3"
}

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

variable "vm_template" {
  description = "VM Template"
  type        = map(string)
  default     = {
    "dc1" = "Win2019GuiDC1" 
    "dc3" = "Win2019GuiDC3"
  }
}

variable "vm_datacenter" {
  description = "Datacenter in vCenter"
  type        = map(string)
  default     = {
    dc1 = "dc01.lon.services.sabio.co.uk" 
    dc3 = "dc03.lon.services.sabio.co.uk" 
  }
  
}