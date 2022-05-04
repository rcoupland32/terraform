resource "null_resource" "terraform_sample"{



provisioner "remote-exec"{
    connection {
    host = var.cust_ip
    type = "winrm"
    timeout = "10m"
    insecure = "true"
    agent    = "false"
    user = "Administrator"
    password = "SabioPass20190522!"
  }

  inline = [
          "powershell Install-WindowsFeature AD-Domain-Services -IncludeManagementTools",
          "powershell Import-Module ADDSDeployment",
          "powershell Install-ADDSForest -CreateDnsDelegation:$false -DatabasePath 'C:\\Windows\\NTDS' -DomainMode 'WinThreshold' -DomainName '${var.cust_domain}' -DomainNetbiosName '${var.cust_shortname}' -ForestMode 'WinThreshold' -InstallDns:$true -LogPath 'C:\\Windows\\NTDS' -NoRebootOnCompletion:$false -SysvolPath 'C:\\Windows\\SYSVOL' -Force:$true -SafeModeAdministratorPassword (ConvertTo-SecureString -AsPlainText -String '${var.cust_safemodepass}' -Force)"

     ]
}
}