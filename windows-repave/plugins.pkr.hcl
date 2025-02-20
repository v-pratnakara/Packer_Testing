### Configure the Plugins for azure 
packer {
 required_version =  ">=1.7.0"
  required_plugins {
    azure = {
      version = ">= 2.1.8"
      source = "github.com/hashicorp/azure"
    }
  }
}

packer {
  required_plugins {
    windows-update = {
      version = ">= 0.10.0"
      source  = "github.com/rgl/windows-update"
    }
  }
}