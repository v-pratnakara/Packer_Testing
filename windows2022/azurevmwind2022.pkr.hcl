source "azure-arm" "windowsimage-2022" {
  #Tags
  azure_tags = {
    environment = "dev"
    owner       = "Phaneendra_r"
    email       = "v-pratnakara@microsoft.com"
    purpose     = "Infra Deployment"
    task        = "packerimages"
  }

  ##Source Images details###
  os_type         = "Windows"
  image_offer     = "WindowsServer"
  image_publisher = "MicrosoftWindowsServer"
  image_sku       = "2022-datacenter-smalldisk-g2"
  vm_size         = "Standard_D2s_v3"
  communicator    = "winrm"
  winrm_use_ssl   = true
  winrm_timeout   = "10m"
  winrm_insecure  = true
  winrm_username  = "packer"

  #Define the network 
  virtual_network_resource_group_name = "Test_VM"
  virtual_network_name                = "v-network"
  virtual_network_subnet_name         = "subnet1"
  temp_compute_name = "win22-vm-poc"
  temp_nic_name     = "packerwin2022-nic-poc"
  build_resource_group_name = "Test_VM"
  temp_os_disk_name  = "packerwin2022-osdisk-poc"
  shared_gallery_image_version_end_of_life_date = "2025-02-28T20:00:05.99Z"


  ### Build Image publish to Target Azure compute galleries###
  shared_image_gallery_destination {
    subscription   = "1901eaa9-e98f-49b6-ac39-b1cd55defe19"
    gallery_name   = "AzurepackerImages"
    image_name     = "win2022dcx64"
    #image_version  = "${formatdate("YYYY.MMDD.hhmm", timestamp())}"
    image_version  = "2.0.0"
    resource_group = "rg-packer-acg"
  }
}