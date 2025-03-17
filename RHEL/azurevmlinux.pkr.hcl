source "azure-arm" "rhel_image" {

  #   #Tags
  azure_tags = {
    environment = "dev"
    owner       = "Phaneendra_r"
    email       = "v-pratnakara@microsoft.com"
    purpose     = "Infra Deployment"
    task        = "packerimages"
    osverison   = "RedhatLinux"
    status      = ""
  }

  # Specify the base image
  vm_size             = "Standard_B2s"
  os_type             = "Linux"
  image_publisher     = "RedHat"
  image_offer         = "RHEL"
  image_sku           = "8-lvm-gen2"
  image_version       =  "latest" # Adjust for the RHEL version and generation you need
  os_disk_size_gb     =  128
  managed_image_storage_account_type = "Premium_LRS"
  disk_encryption_set_id = "/subscriptions/1901eaa9-e98f-49b6-ac39-b1cd55defe19/resourceGroups/Test_VM/providers/Microsoft.Compute/diskEncryptionSets/packerdes"
  communicator        = "ssh"
  ssh_username        = "packerlinux"
  ssh_clear_authorized_keys  = true
  ssh_port  =  22
  temp_compute_name = "packerlinux-vm-poc"
  temp_nic_name     = "packerlinux-nic-poc"
  build_resource_group_name = "Test_VM"
  temp_os_disk_name  = "packerlinux-osdisk-poc"
  #shared_gallery_image_version_end_of_life_date = "2025-03-06T20:00:05.99Z"
  #Define the network
  virtual_network_resource_group_name = "Test_VM"
  virtual_network_name                = "v-network"
  virtual_network_subnet_name         = "subnet1"


 ## Build Image publish to Target Azure compute galleries###

  shared_image_gallery_destination {
    subscription   = "1901eaa9-e98f-49b6-ac39-b1cd55defe19"
    gallery_name   = "AzurepackerImages"
    image_name     = "linux8x64"
    image_version  = "5.0.3"
    #image_version = formatdate("YYYY.MMDD.hhmm", timestamp())
    resource_group = "rg-packer-acg"
  }

}