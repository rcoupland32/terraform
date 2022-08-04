#variable "cust_domain" {
#  description = "Customer Domain Name"
#  type        = string
#  default     = "tcom.services.sabio.co.uk"
#}

variable "cust_shortname"{
  description = "customer shortname" #lowercase only
  type        = string
  default     = "ARE YOU WORKING??"
}

variable "cust_vlan" {
  description = "Customer VLAN number for deployment"
  type        = string
  default     = 51
}

variable "vm_datastore" {
  description = "Datastore name where VM will be deployed"
  type        = string
  default     = "vSANDatastore08"
}

variable "vm_cluster" {
  description = "Cluster VM will be deployed to"
  type        = string
  default     = "DC1-VSAN8-D17"
}

variable "vm_network"{
  description = "NIC network to assign to VMs"
  type        = string
  default     = "pg51Management"
}

variable "vm_folder"{
  description = "Folder to Place VM inside (include parent directories if applicable)"
  type        = string
  default     = "Management"
}

variable "vm_template" {
  description = "VM Template"
  type        = string
  default     = "Win2022GuiDC1" #Win2019GuiDC1
}

variable "vm_admintemplate" {
  description = "VM Template"
  type        = string
  default     = "Win2022AdmDC1" #Win2019AdmDC1
}

variable "vm_datacenter" {
  description = "Datacenter in vCenter"
  type        = string
  default     = "dc01.lon.services.sabio.co.uk" #dc01.lon.services.sabio.co.uk
  }

variable "vm_isofile" {
  description = "ISO File to Attach to VM"
  type = string
  default = "[DC03-ISOIMG] WindowsInstallers/Installers.iso" #[DC01-ISOIMG] ISO/WindowsInstallers/Installers.iso

}

#Doesnt need changed
variable "vmware_username" {
  description = "vSphere username"
  type        = string
  sensitive   = true
  default     = "svcterraform"
}

variable "vmware_password" {
  description = "vSphere Password"
  type        = string
  sensitive   = true
}

variable "cust_adminpassword"{
  description = "Domain Admin password"
  type        = string
  sensitive   = true
}
