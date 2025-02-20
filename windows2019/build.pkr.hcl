build {
    sources = [ "source.azure-arm.windowsimage-2019" ]

  provisioner "windows-update" {
   }

 # Provisioner: Install IIS (as an example)
  provisioner "powershell" {
    inline = [
      "Install-WindowsFeature -name Web-Server -IncludeManagementTools",
      "$feature = Get-WindowsFeature -Name Web-Server",
      "if ($feature.Installed) { Write-Host 'IIS Installed Successfully.' } else { Write-Host 'IIS Installation Failed'; Exit 1 }"
    ]
  }

  # Provisioner: Run a simple script to create a text file (as an example)
  provisioner "powershell" {
    inline = [
      "New-Item -Path C:/ -Name 'testfile.txt' -ItemType 'file' -Value 'This is a test file.'"
    ]
  }

  # Provisioner: Restart Windows to apply the changes
  provisioner "windows-restart" {
    restart_timeout = "5m"
  }

         provisioner "powershell" {
         inline = [
           "winrm quickconfig -force",
    
           "New-NetFirewallRule -Name 'WinRM HTTP' -DisplayName 'WinRM HTTP' -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 5985",
    
          "$ICMP = Get-NetFirewallRule -DisplayName 'File and Printer Sharing (Echo Request - ICMPv4-In)'",
          "If ($ICMP -eq $null) {",
          "  write-host 'ICMP is not enabled'",
          "} elseif ($ICMP -ne $null) {",
          "  write-host 'ICMP is enabled, turning on now'",
          "  Set-NetFirewallRule -DisplayName 'File and Printer Sharing (Echo Request - ICMPv4-In)' -enabled True",
          "}",
    
         "$ICMP = Get-NetFirewallRule -DisplayName 'File and Printer Sharing (Echo Request - ICMPv6-In)'",
         "If ($ICMP -eq $null) {",
         "  write-host 'ICMP is not enabled'",
          "} elseif ($ICMP -ne $null) {",
         "  write-host 'ICMP is enabled, turning on now'",
          "  Set-NetFirewallRule -DisplayName 'File and Printer Sharing (Echo Request - ICMPv6-In)' -enabled True",
         "}"
       ]
     }
   
 

 provisioner "powershell" {
    inline = ["while ((Get-Service RdAgent).Status -ne 'Running') { Start-Sleep -s 5 }", "while ((Get-Service WindowsAzureGuestAgent).Status -ne 'Running') { Start-Sleep -s 5 }", "& $env:SystemRoot\\System32\\Sysprep\\Sysprep.exe /oobe /generalize /quiet /quit /mode:vm", "while($true) { $imageState = Get-ItemProperty HKLM:\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Setup\\State | Select ImageState; if($imageState.ImageState -ne 'IMAGE_STATE_GENERALIZE_RESEAL_TO_OOBE') { Write-Output $imageState.ImageState; Start-Sleep -s 10  } else { break } }"]
  }

} 


