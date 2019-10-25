####################################
# vCenter Configuration
####################################
variable "vsphere_allow_unverified_ssl" {
  default = true
}
variable "vsphere_server" {
  default = "10.76.162.35"
}
variable "ssh_user" {
  default = "root"
}
variable "ssh_password" {
  default = "a1b2c3d4"
}
variable "vsphere_datacenter" {
  default = "cp-mcms"
}
variable "vsphere_cluster" {
  default = "cp-mcms"
}
variable "vsphere_resource_pool" {
  default = "cp-mcms"
}
variable "datastore_cluster" {
  default = "cp-mcms-dsc"
}
variable "datastore" {
  default = "NFS"
}

variable "template" {
  default = "rhel7.5_tmp"
}
variable "folder" {
  default = "cp-folder"
}

#variable "vsphere_server" {}
#variable "vsphere_allow_unverified_ssl" {
#  default = true
#}

#variable "vsphere_datacenter" {}
#variable "vsphere_cluster" {}
#variable "vsphere_resource_pool" {}
#variable "datastore" {
#  default = ""
#}
#variable "datastore_cluster" {
#  default = ""
#}
#variable "template" {}
#variable "folder" {}

####################################
# Infrastructure Configuration
####################################


variable "hostname_prefix" {
  default = "CP-OCP"
}

variable "ssh_private_key_file" {
  default = "~/.ssh/id_rsa"
}

variable "ssh_public_key_file" {
  default = "~/.ssh/id_rsa.pub"
}

variable "bastion_ssh_private_key_file" {
  default = "~/.ssh/id_rsa"
}
#######################
variable "private_network_label" {
  default = "managementportgroup"
}
variable "private_staticipblock" {
  default = "10.76.162.32/28"
}
variable "private_staticipblock_offset" {
  default = "4"
}
variable "private_gateway" {
  default = "10.76.162.33"
}
variable "private_netmask" {
  default = "28"
}
variable "private_domain" {
  default = "cloudpak.lab"
}
variable "private_dns_servers" {
  type = "list"
  default = [ "10.76.190.125" ]
}

variable "bastion_private_ip" {
  type = "list"
  default = [ "10.76.162.39" ]
}

variable "master_private_ip" {
  type = "list"
  default = [ "10.76.162.40", "10.76.162.41", "10.76.162.42" ]
}

variable "infra_private_ip" {
  type = "list"
  default = [ "10.76.162.43" ]
}

variable "worker_private_ip" {
  type = "list"
  default = [ "10.76.162.44", "10.76.162.45", "10.76.162.46" ]
}

variable "storage_private_ip" {
  type = "list"
  default = []
}
###############################


variable "public_network_label" {
  default = "public"
}

variable "public_staticipblock" {
  default = "173.193.126.48/28"
}

variable "public_staticipblock_offset" {
  default = "2"
}

variable "public_netmask" {
  default = "28"
}

variable "public_gateway" {
  default = "173.193.126.49"
}

variable "public_domain" {
  default = ""
}

variable "public_dns_servers" {
  type = "list"
  default = [ "1.1.1.1" ]
}

variable "bastion" {
  type = "map"

  default = {
    nodes               = "1"
    vcpu                = "2"
    memory              = "8192"
    disk_size           = "150"      # Specify size or leave empty to use same size as template.
    docker_disk_size    = "100"
    thin_provisioned    = "true"      # True or false. Whether to use thin provisioning on the disk. Leave blank to use same as template
    eagerly_scrub       = "false"      # True or false. If set to true disk space is zeroed out on VM creation. Leave blank to use same as template
    keep_disk_on_remove = "false" # Set to 'true' to not delete a disk on removal.
  }
}

variable "master" {
  type = "map"

  default = {
    nodes                 = "3"
    vcpu                  = "16"
    memory                = "32768"
    disk_size             = "150"      # Specify size or leave empty to use same size as template.
    docker_disk_size      = "200"   # Specify size for docker disk, default 100.
    thin_provisioned      = "true"      # True or false. Whether to use thin provisioning on the disk. Leave blank to use same as template
    eagerly_scrub         = "false"      # True or false. If set to true disk space is zeroed out on VM creation. Leave blank to use same as template
    keep_disk_on_remove   = "false" # Set to 'true' to not delete a disk on removal.
  }
}

variable "infra" {
  type = "map"

  default = {
    nodes               = "1"
    vcpu                = "8"
    memory              = "32768"
    disk_size           = "150"      # Specify size or leave empty to use same size as template.
    docker_disk_size    = "200"   # Specify size for docker disk, default 100.
    thin_provisioned    = "true"      # True or false. Whether to use thin provisioning on the disk. Leave blank to use same as template
    eagerly_scrub       = "false"      # True or false. If set to true disk space is zeroed out on VM creation. Leave blank to use same as template
    keep_disk_on_remove = "false" # Set to 'true' to not delete a disk on removal.
  }
}

variable "worker" {
  type = "map"

  default = {
    nodes               = "3"
    vcpu                = "16"
    memory              = "65536"
    disk_size           = "150"      # Specify size or leave empty to use same size as template.
    docker_disk_size    = "200"   # Specify size for docker disk, default 100.
    thin_provisioned    = "true"      # True or false. Whether to use thin provisioning on the disk. Leave blank to use same as template
    eagerly_scrub       = "false"      # True or false. If set to true disk space is zeroed out on VM creation. Leave blank to use same as template
    keep_disk_on_remove = "false" # Set to 'true' to not delete a disk on removal.
  }
}

variable "storage" {
  type = "map"

  default = {
    nodes               = "0"
    vcpu                = "4"
    memory              = "8192"
    disk_size           = ""      # Specify size or leave empty to use same size as template.
    docker_disk_size    = "100"   # Specify size for docker disk, default 100.
    thin_provisioned    = ""      # True or false. Whether to use thin provisioning on the disk. Leave blank to use same as template
    eagerly_scrub       = ""      # True or false. If set to true disk space is zeroed out on VM creation. Leave blank to use same as template
    keep_disk_on_remove = "false" # Set to 'true' to not delete a disk on removal.
  }
}

####################################
# RHN Registration
####################################
variable "rhn_username" {
  default = "ashisharora"  
}
variable "rhn_password" {
  default = "Ash1105326"
}
variable "rhn_poolid" {
  default = "8a85f99b6c5350c8016c67a85b772de6"
}
####################################
# DNS Registration & Certificates
####################################

variable "cloudflare_email" {
  default = ""
}
variable "cloudflare_token" {
  default = ""
}
variable "cloudflare_zone" {
  default = ""
}

variable "master_cname" {
  default = "master"
}
variable "app_cname" {
  description = "wildcard app domain (don't add the *. prefix)"
  default = "app"
}
#variable "letsencrypt_email" {}

variable "letsencrypt_api_endpoint" {
  default = "https://acme-v02.api.letsencrypt.org/directory"
}

#variable "letsencrypt_dns_provider" {}

####################################
# OpenShift Installation
####################################
variable "network_cidr" {
  default = "10.128.0.0/14"
}

variable "service_network_cidr" {
  default = "172.30.0.0/16"
}

variable "host_subnet_length" {
  default = 9
}

variable "ose_version" {
  default = "3.11"
}

variable "ose_deployment_type" {
  default = "openshift-enterprise"
}

variable "image_registry" {
  default = "registry.redhat.io"
}

variable "image_registry_path" {
  default = "/openshift3/ose-$${component}:$${version}"
}

variable "image_registry_username" {
  default = "ashisharora"
}

variable "image_registry_password" {
  default = "Ash1105326"
}

variable "registry_volume_size" {
  default = "100"
}

variable "cloudprovider" {
  default = "ibm"
}

variable "icp_binary" {
  default = "nfs://jumper.rtp.raleigh.ibm.com/catalog/rhos/ibm-cloud-private-rhos-3.2.0.1907.tar.gz"
}

variable "icp_install_path" {
  default = "/opt/ibm-cloud-private-rhos-3.2.0"
}

variable "storage_class" {
  default = "glusterfs-storage"
}

#variable "dns_key_name" {}
#variable "dns_key_algorithm" {}
#variable "dns_key_secret" {}
#variable "dns_record_ttl" {}

variable "vsphere_storage_username" {
  default = ""
}

variable "vsphere_storage_password" {
  default = ""
}

variable "vsphere_storage_datastore" {
  default = ""
}
