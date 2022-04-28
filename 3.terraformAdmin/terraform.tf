provider "vsphere" {
  user           = var.vmware_username
  password       = var.vmware_password
  vsphere_server = "vcenter.dc01.lon.services.sabio.co.uk"
#  version = "~&gt; 1.11"

  # If you have a self-signed cert
  allow_unverified_ssl = true
}

#Data Sources
data "vsphere_datacenter" "dc" {
  name = var.vm_datacenter["dc3"]
}

data "vsphere_datastore" "datastore" {
  name          = var.vm_datastore
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_compute_cluster" "cluster" {
  name          = var.vm_cluster
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_network" "network" {
  name          = var.vm_network
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_virtual_machine" "template" {
  name          = var.vm_template["dc3"]
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

#Virtual Machine Resource
resource "vsphere_virtual_machine" "adminvm" {
  name             = var.vm_name
  resource_pool_id = "${data.vsphere_compute_cluster.cluster.resource_pool_id}"
  datastore_id     = "${data.vsphere_datastore.datastore.id}"

  num_cpus = 2
  memory   = 4096
  guest_id = "${data.vsphere_virtual_machine.template.guest_id}"

  scsi_type = "${data.vsphere_virtual_machine.template.scsi_type}"
  #firmware = "efi"

  network_interface {
    network_id   = "${data.vsphere_network.network.id}"
    adapter_type = "vmxnet3"
  }

  disk {
    label            = "OS"
    size             = 60
    eagerly_scrub    = "${data.vsphere_virtual_machine.template.disks.0.eagerly_scrub}"
    thin_provisioned = "${data.vsphere_virtual_machine.template.disks.0.thin_provisioned}"
}
  disk {
    label	     = "Data"
    size 	     = 100
    unit_number      = 1
  }


  clone {
    template_uuid = "${data.vsphere_virtual_machine.template.id}"

    customize {
      windows_options {
        computer_name  = var.os_name
        join_domain           = var.domain
        domain_admin_user     = var.domain_admin_user
        domain_admin_password = "SabioPass20190522!"
        admin_password = "SabioPass20190522!"
      }

      network_interface {
        ipv4_address = "10.203.${var.cust_vlan}.50"
        ipv4_netmask = 24
      }

      ipv4_gateway = "10.203.${var.cust_vlan}.254"
    }
  }
}
