provider "vsphere" {
  user           = var.vmware_username
  password       = var.vmware_password
  vsphere_server = "vcenter.dc01.lon.services.sabio.co.uk"
#  version = "~&gt; 1.11"

  # If you have a self-signed cert
  allow_unverified_ssl = true
}

#Data Sources
data "vsphere_datacenter" "dc-01" {
  name = var.vm_datacenter
}

data "vsphere_datastore" "datastore-01" {
  name          = var.vm_datastore
  datacenter_id = "${data.vsphere_datacenter.dc-01.id}"
}

data "vsphere_compute_cluster" "cluster-01" {
  name          = var.vm_cluster
  datacenter_id = "${data.vsphere_datacenter.dc-01.id}"
}

data "vsphere_network" "network-01" {
  name          = var.vm_network #"pg13${var.cust_vlan}${var.cust_shortname}Apps"
  datacenter_id = "${data.vsphere_datacenter.dc-01.id}"
}

data "vsphere_virtual_machine" "template-01" {
  name          = var.vm_template
  datacenter_id = "${data.vsphere_datacenter.dc-01.id}"
}

#data "vsphere_datastore" "iso-01" {
#  name          = var.vm_isodatastore
#  datacenter_id = "${data.vsphere_datacenter.dc-01.id}"
#}


#Virtual Machine Resource
resource "vsphere_virtual_machine" "A-domaincontroller" {
  name   = upper("${var.cust_vlan}_${var.cust_shortname}_DC01")
  resource_pool_id = "${data.vsphere_compute_cluster.cluster-01.resource_pool_id}"
  datastore_id     = "${data.vsphere_datastore.datastore-01.id}"
  count            = "1"

provisioner "remote-exec"{

    connection {
    host = "10.203.${var.cust_vlan}.2"
    type = "winrm"
    timeout = "10m"
    insecure = "true"
    agent    = "false"
    user = "Administrator"
    password = var.cust_adminpassword
  }

  inline = [
          
          "powershell Install-WindowsFeature AD-Domain-Services -IncludeManagementTools",
          "powershell Import-Module ADDSDeployment",
          "powershell Install-ADDSForest -CreateDnsDelegation:$false -DatabasePath 'C:\\Windows\\NTDS' -DomainMode 'WinThreshold' -DomainName '${var.cust_shortname}.services.sabio.co.uk' -DomainNetbiosName '${var.cust_shortname}' -ForestMode 'WinThreshold' -InstallDns:$true -LogPath 'C:\\Windows\\NTDS' -NoRebootOnCompletion:$false -SysvolPath 'C:\\Windows\\SYSVOL' -Force:$true -SafeModeAdministratorPassword (ConvertTo-SecureString -AsPlainText -String '${var.cust_adminpassword}' -Force)"

     ]
}
  num_cpus = 2
  memory   = 4096
  folder   = var.vm_folder
  guest_id = "${data.vsphere_virtual_machine.template-01.guest_id}"

  scsi_type = "${data.vsphere_virtual_machine.template-01.scsi_type}"
  #firmware = "efi"

  network_interface {
    network_id   = "${data.vsphere_network.network-01.id}"
    adapter_type = "vmxnet3"
  }

  disk {
    label            = "OS"
    size             = 60
    eagerly_scrub    = "${data.vsphere_virtual_machine.template-01.disks.0.eagerly_scrub}"
    thin_provisioned = "${data.vsphere_virtual_machine.template-01.disks.0.thin_provisioned}"
}



  clone {
    template_uuid = "${data.vsphere_virtual_machine.template-01.id}"

    customize {
      windows_options {
        computer_name   = "dc01-${var.cust_shortname}"
        workgroup       = "SABIO"
        #join_domain           = "test.lab"
        #domain_admin_user     = "administrator"
        #domain_admin_password = "SabioPass20190522!"
        admin_password = var.cust_adminpassword
        
        
      }

      network_interface {
        ipv4_address = "10.203.${var.cust_vlan}.${2 + count.index}"
        ipv4_netmask = 24
        dns_server_list = ["10.203.${var.cust_vlan}.2", "10.203.${var.cust_vlan}.3"]
      }

      ipv4_gateway = "10.203.${var.cust_vlan}.254"
    
  }
}
}

