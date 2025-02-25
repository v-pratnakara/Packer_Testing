source "azure-arm" "windowsimage-2019-repave" {
  #Tags
  azure_tags = {
    environment = "dev"
    owner       = "Phaneendra_r"
    email       = "v-pratnakara@microsoft.com"
    purpose     = "Infra Deployment"
    task        = "packerimages-repave"
  }

  ##Source Images details###
  os_type         = "Windows"
  # image_offer     = "WindowsServer"
  # image_publisher = "MicrosoftWindowsServer"
  # image_sku       = "2019-datacenter-gensecond"
  vm_size         = "Standard_D2s_v3"
  communicator    = "winrm"
  winrm_use_ssl   = true
  winrm_timeout   = "10m"
  winrm_insecure  = true
  winrm_username  = "packer"
  temp_compute_name = "win2019-vm-poc"
  temp_nic_name     = "win2019-nic-poc"
  build_resource_group_name = "Test_VM"
  temp_os_disk_name  = "win2019-osdisk-poc"
  #security_type = "TrustedLaunch"


  #Define the network 
  virtual_network_resource_group_name = "Test_VM"
  virtual_network_name                = "v-network"
  virtual_network_subnet_name         = "subnet1"

    # Source image
  shared_image_gallery {
    subscription   = "1901eaa9-e98f-49b6-ac39-b1cd55defe19"
    gallery_name   = "AzurepackerImages"  ##Azure Shared Gallery name
    image_name     = "win2019dcx64"      ## Image definition name
    image_version  = "latest"
    resource_group = "rg-packer-acg"
  }

  ### Build Image publish to Target Azure compute galleries###
  shared_image_gallery_destination {
    subscription   = "1901eaa9-e98f-49b6-ac39-b1cd55defe19"
    gallery_name   = "AzurepackerImages"
    image_name     = "win2019x64-repave"
    image_version  = "${formatdate("YYYY.MMDD.hhmm", timestamp())}"
    resource_group = "rg-packer-acg"
  }
}