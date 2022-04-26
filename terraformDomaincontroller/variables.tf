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
  default     = "0_TerraformTest_DC0"
}

variable "os_name" {
  description = "OS Hostname"
  type        = string
  default     = "test-dc0"
}

variable "cust_vlan" {
  description = "Customer VLAN number for deployment"
  type        = string
  default     = 95
}

variable "vm_datacenter" {
  description = "Datacenter in vCenter"
  type        = map(string)
  default     = {
    dc1 = "dc01.lon.services.sabio.co.uk" 
    dc3 = "dc03.lon.services.sabio.co.uk" 
  }
  
}

variable "vm_datastore" {
  description = "Datastore name where VM will be deployed"
  type        = map(string)
  default     = {
    dc1vsan04    = "vSANDatastore04"
    dc1vsan05    = "vSANDatastore05"
    dc1vsan07    = "vSANDatastore07"
    dc1vsan08    = "vSANDatastore08"
    dc3vsan01    = "DC3vSANDatastore01"
    dc3vsan02    = "DC3vSANDatastore02"
    dc3vsan03    = "DC3vSANDatastore03"
    dc3vsan04win = "DC3vSANDatastore04Windows"
    dc3vsan04lin = "DC3vSANDatastore04Linux"
  }
}

variable "vm_cluster" {
  description = "Cluster VM will be deployed to"
  type        = map(string)
  default     = {
    "dc1vsan4"      = "DC1-VSAN4-D5"
    "dc1vsan5"      = "DC1-VSAN5-D5"
    "dc1vsan7"      = "DC1-VSAN7-B17"
    "dc1vsan8"      = "DC1-VSAN8-D17"
    "dc3vsan1"      = "DC3-VSAN1-81009"
    "dc3vsan2"      = "DC3-VSAN2-81009"
    "dc3vsan3"      = "DC3-VSAN3-81009"
    "dc3vsan4win"   = "DC3-VSAN4-Windows-80712"
    "dc3vsan4lin"   =  "DC3-VSAN4-Linux-80712"

  }
}

variable "vm_network"{
  description = "NIC network to assign to VMs"
  type        = string
  default     = "pg999Isolated_DC3"
}

variable "vm_template" {
  description = "VM Template"
  type        = map(string)
  default     = {
    "DC1" = "Win2019GuiDC1" 
    "DC3" = "Win2019GuiDC3"
  }
}