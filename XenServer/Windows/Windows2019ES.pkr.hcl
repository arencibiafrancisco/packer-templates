packer {
  required_plugins {
    xenserver = {
      version = ">= v0.7.0"
      source  = "github.com/ddelnano/xenserver"
    }
  }
}

variable "remote_host" {
  type        = string
  description = "The IP or FQDN of your XCP-ng. It must be the master"
  sensitive   = true
  default     = "10.35.1.6"
}

variable "remote_username" {
  type        = string
  description = "The username used to interact with your XCP-ng"
  sensitive   = true
  default     = "root"
}

variable "remote_password" {
  type        = string
  description = "The password used to interact with your XCP-ng"
  sensitive   = true
  default     = "Node_Password"
}

variable "sr_iso_name" {
  type        = string
  description = "The ISO-SR Packer will use"
  default     = "PROD172_NFS171COREC14_ST19_ISOS"
}

variable "sr_name" {
  type        = string
  description = "The name of the SR Packer will use"
  default     = "PROD171_NFS171COREC14_ST19"
}

source "xenserver-iso" "windows2019" {
  iso_checksum                 = "7fa9ae86628a414fc7f485f897c084d74cacb8c3d6de3d54737bffb453649b9931a65655784b09ddccac95582fd25782bc24b40dbeb9386b8cc4799f80d99de2"
  iso_url                      = "http://10.35.10.130:8081/repository/ISOS/Windows2019ES.iso"
  sr_iso_name                  = var.sr_iso_name
  sr_name                      = var.sr_name
  remote_host                  = var.remote_host
  remote_password              = var.remote_password
  remote_username              = var.remote_username
  ssh_disable_agent_forwarding = true
  ssh_pty                      = true

  boot_command = [
    "<wait><wait><wait><enter>"
  ]

  vm_name         = "Win2019ES_template"
  vm_description  = "VM for Windows Server 2019 ES"
  vcpus_max       = 4
  vcpus_atstartup = 4
  vm_memory       = 16384 # MB
  network_names   = ["MAD4-CORE-ADM-MGMT-VLAN60"]
  disk_size       = 81920 # MB
  disk_name       = "Win2019ES_template_disk"
  floppy_files = [
    "./floppy/es19/autounattend.xml",
    "./floppy/es19/cloudbase-init-unattend.conf",
    "./floppy/es19/cloudbase-init.conf",
    "./floppy/es19/Unattend.xml",
    "./floppy/es19/winunattend.xml",
    "./scripts/Cleanup.ps1",
    "./scripts/ConfigureRemotingForAnsible.ps1",
    "./scripts/CopyFiles.ps1",
    "./scripts/WinUpdate.ps1",
    "./scripts/InstallInitialSetup.ps1",
    "./scripts/Sysprep.ps1"
  ]
  vm_tags                = ["Generated by Packer"]
  communicator           = "winrm"
  winrm_username         = "Administrador"
  winrm_password         = "Password2022!"
  winrm_timeout          = "6h"
  winrm_insecure         = true
  winrm_use_ssl          = true
  ssh_username           = "Administrador"
  ssh_password           = "Password2022!"
  ssh_wait_timeout       = "60000s"
  ssh_handshake_attempts = 10000
  output_directory       = "packer-Win2019ES"
  keep_vm                = "never"
  format                 = "vdi_vhd"
  shutdown_command       = "shutdown /s /t 5 /f /d p:4:1 /c \\\"Packer Shutdown\\\""
}

build {
  name    = "Win2019ES-XenServer"
  sources = ["xenserver-iso.windows2019"]

  provisioner "powershell" {
    scripts          = ["scripts/WinUpdate.ps1"]
    valid_exit_codes = [0, 2300218]
  }

  provisioner "windows-restart" {
    pause_before    = "30s"
    restart_timeout = "30m"
  }

  provisioner "powershell" {
    scripts = ["scripts/WinUpdate.ps1"]
  }

  provisioner "windows-restart" {
    restart_timeout = "30m"
  }

  provisioner "powershell" {
    scripts = ["scripts/Cleanup.ps1"]
  }

  provisioner "powershell" {
    scripts = ["scripts/Sysprep.ps1"]
  }
}
