build {
  name = "rhel-sig-image-build"

  sources = ["source.azure-arm.rhel_image"]

 provisioner "shell" {
    inline = [
      "echo 'Starting system update...'",
      "sudo yum update -y",
      "echo 'Installing httpd...'",
      "sudo yum install -y httpd",
      "sudo systemctl enable httpd",
      "sudo systemctl start httpd",
      "echo 'Sleeping for 5 seconds to ensure httpd service starts properly...'",
      "sleep 15",
      "echo 'system update completed!'"
    ]
  }

  provisioner "shell" {
    inline = [
      "echo 'Starting sleep...'",
      "sleep 60",
      "echo 'Sleep completed.'"
    ]
  }

  provisioner "shell" {
    inline = [
      "echo 'Configuring waagent service...'",
      "sudo systemctl enable waagent",
      "sudo systemctl restart waagent",
      "sudo waagent -force -deprovision+user && export HISTSIZE=0 && sync"
    ]
  }


}  