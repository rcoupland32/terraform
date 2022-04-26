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
  name = "dc03.lon.services.sabio.co.uk"
}

data "vsphere_datastore" "datastore" {
  name          = "DC3vSANDatastore02"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_compute_cluster" "cluster" {
  name          = "DC3-VSAN2-81009"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_network" "network" {
  name          = "pg999Isolated_DC3"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_virtual_machine" "template" {
  name          = "Win2016GuiDC3"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

#Virtual Machine Resource
resource "vsphere_virtual_machine" "testvm" {
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
    label            = "disk0"
    size             = 60
    eagerly_scrub    = "${data.vsphere_virtual_machine.template.disks.0.eagerly_scrub}"
    thin_provisioned = "${data.vsphere_virtual_machine.template.disks.0.thin_provisioned}"
  }

  clone {
    template_uuid = "${data.vsphere_virtual_machine.template.id}"

    customize {
      windows_options {
        computer_name  = "Ryan-Test"
        workgroup      = "SABIO"
        admin_password = "SabioPass20190522!"
      }

      network_interface {
        ipv4_address = "172.23.10.22"
        ipv4_netmask = 24
      }

      ipv4_gateway = "172.23.10.254"
    }
  }
}
