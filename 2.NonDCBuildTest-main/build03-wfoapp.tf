#provider "vsphere" {
#  user           = var.vmware_username
#  password       = var.vmware_password
#  vsphere_server = "vcenter.dc01.lon.services.sabio.co.uk"
##  version = "~&gt; 1.11"
#
#  # If you have a self-signed cert
#  allow_unverified_ssl = true
#}

#Data Sources
data "vsphere_datacenter" "dc-03" {
  name = var.vm_datacenter
}

data "vsphere_datastore" "datastore-03" {
  name          = var.vm_datastore
  datacenter_id = "${data.vsphere_datacenter.dc-03.id}"
}

data "vsphere_compute_cluster" "cluster-03" {
  name          = var.vm_cluster
  datacenter_id = "${data.vsphere_datacenter.dc-03.id}"
}

data "vsphere_network" "network-03" {
  name          = var.vm_network
  datacenter_id = "${data.vsphere_datacenter.dc-03.id}"
}

data "vsphere_virtual_machine" "template-03" {
  name          = var.vm_template
  datacenter_id = "${data.vsphere_datacenter.dc-03.id}"
}

#data "vsphere_folder" "folder-03" {
#  path = "/${var.vm_datacenter}/vm/Management_DC3/${var.cust_shortname}"
#}

#Virtual Machine Resource
resource "vsphere_virtual_machine" "C-wfoapp" {
  name   = upper("${var.cust_vlan}_${var.cust_shortname}_WFOAPP0${count.index + 1}")
  resource_pool_id = "${data.vsphere_compute_cluster.cluster-03.resource_pool_id}"
  datastore_id     = "${data.vsphere_datastore.datastore-03.id}"
  count            = "6"
  

  num_cpus = 2
  memory   = 4096
  folder   = var.vm_folder
  guest_id = "${data.vsphere_virtual_machine.template-03.guest_id}"

  scsi_type = "${data.vsphere_virtual_machine.template-03.scsi_type}"
  firmware = "efi"

  network_interface {
    network_id   = "${data.vsphere_network.network-03.id}"
    adapter_type = "vmxnet3"
  }

  disk {
    label            = "OS"
    size             = 60
    eagerly_scrub    = "${data.vsphere_virtual_machine.template-03.disks.0.eagerly_scrub}"
    thin_provisioned = "${data.vsphere_virtual_machine.template-03.disks.0.thin_provisioned}"
}


  clone {
    template_uuid = "${data.vsphere_virtual_machine.template-03.id}"

    customize {
      windows_options {
        computer_name   = "wfoapp0${count.index + 1}-${var.cust_shortname}"
        join_domain           = "${var.cust_shortname}.services.sabio.co.uk"
        domain_admin_user     = "Administrator"
        domain_admin_password = var.cust_adminpassword
        admin_password = var.cust_adminpassword
        
        
      }

      network_interface {
        ipv4_address = "10.203.${var.cust_vlan}.${65 + count.index}"
        ipv4_netmask = 24
        dns_server_list = ["10.203.${var.cust_vlan}.2", "10.203.${var.cust_vlan}.3"]
      }

      ipv4_gateway = "10.203.${var.cust_vlan}.254"
    
  }
}
}
