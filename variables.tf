####################################
# vCenter Configuration
####################################
variable "vsphere_server" {}

variable "vsphere_datacenter" {}
variable "vsphere_cluster" {}
variable "vsphere_resource_pool" {}
variable "network_label" {}
variable "bastion_network_label" {}
variable "datastore" {}
variable "template" {}

####################################
# Infrastructure Configuration
####################################

variable "domain" {
  default = ""
}

variable "hostname_prefix" {
  default = ""
}

variable "private_ssh_key" {
  default = "~/.ssh/openshift_rsa"
}

variable "public_ssh_key" {
  default = "~/.ssh/openshift_rsa.pub"
}

variable "bastion_ssh_key_file" {
  default = "~/.ssh/openshift_rsa"
}

variable "bastion_staticipblock" {}
variable "bastion_staticipblock_offset" {}
variable "bastion_gateway" {}
variable "bastion_netmask" {}

variable "bastion_dns_servers" {
  type = "list"
}

variable "staticipblock" {}
variable "staticipblock_offset" {}
variable "gateway" {}
variable "netmask" {}

variable "dns_servers" {
  type = "list"
}

variable "ssh_user" {}
variable "ssh_password" {}

variable "bastion" {
  type = "map"

  default = {
    nodes               = "1"
    vcpu                = "2"
    memory              = "8192"
    disk_size           = ""      # Specify size or leave empty to use same size as template.
    datastore_disk_size = "50"    # Specify size datastore directory, default 50.
    thin_provisioned    = ""      # True or false. Whether to use thin provisioning on the disk. Leave blank to use same as template
    eagerly_scrub       = ""      # True or false. If set to true disk space is zeroed out on VM creation. Leave blank to use same as template
    keep_disk_on_remove = "false" # Set to 'true' to not delete a disk on removal.
    start_iprange       = ""      # Leave blank for DHCP, else masters will be allocated range starting from this address
  }
}

variable "master" {
  type = "map"

  default = {
    nodes                 = "1"
    vcpu                  = "4"
    memory                = "16384"
    disk_size             = ""      # Specify size or leave empty to use same size as template.
    docker_disk_size      = "100"   # Specify size for docker disk, default 100.
    docker_disk_device    = ""
    datastore_disk_size   = "50"    # Specify size datastore directory, default 50.
    datastore_etcd_size   = "50"    # Specify size etcd datastore directory, default 50.
    thin_provisioned_etcd = ""      # True or false. Whether to use thin provisioning on the disk. Leave blank to use same as template
    thin_provisioned      = ""      # True or false. Whether to use thin provisioning on the disk. Leave blank to use same as template
    eagerly_scrub         = ""      # True or false. If set to true disk space is zeroed out on VM creation. Leave blank to use same as template
    keep_disk_on_remove   = "false" # Set to 'true' to not delete a disk on removal.
    start_iprange         = ""      # Leave blank for DHCP, else masters will be allocated range starting from this address
  }
}

variable "infra" {
  type = "map"

  default = {
    nodes               = "1"
    vcpu                = "4"
    memory              = "16384"
    disk_size           = ""      # Specify size or leave empty to use same size as template.
    docker_disk_size    = "100"   # Specify size for docker disk, default 100.
    docker_disk_device  = ""
    thin_provisioned    = ""      # True or false. Whether to use thin provisioning on the disk. Leave blank to use same as template
    eagerly_scrub       = ""      # True or false. If set to true disk space is zeroed out on VM creation. Leave blank to use same as template
    keep_disk_on_remove = "false" # Set to 'true' to not delete a disk on removal.
    start_iprange       = ""      # Leave blank for DHCP, else proxies will be allocated range starting from this address
  }
}

variable "worker" {
  type = "map"

  default = {
    nodes               = "1"
    vcpu                = "8"
    memory              = "16384"
    disk_size           = ""      # Specify size or leave empty to use same size as template.
    docker_disk_size    = "100"   # Specify size for docker disk, default 100.
    docker_disk_device  = ""
    thin_provisioned    = ""      # True or false. Whether to use thin provisioning on the disk. Leave blank to use same as template
    eagerly_scrub       = ""      # True or false. If set to true disk space is zeroed out on VM creation. Leave blank to use same as template
    keep_disk_on_remove = "false" # Set to 'true' to not delete a disk on removal.
    start_iprange       = ""      # Leave blank for DHCP, else workers will be allocated range starting from this address
  }
}

variable "storage" {
  type = "map"

  default = {
    nodes               = "3"
    vcpu                = "4"
    memory              = "8192"
    disk_size           = ""      # Specify size or leave empty to use same size as template.
    docker_disk_size    = "100"   # Specify size for docker disk, default 100.
    docker_disk_device  = ""
    log_disk_size       = "50"    # Specify size for /opt/ibm/cfc for log storage, default 50
    thin_provisioned    = ""      # True or false. Whether to use thin provisioning on the disk. Leave blank to use same as template
    eagerly_scrub       = ""      # True or false. If set to true disk space is zeroed out on VM creation. Leave blank to use same as template
    keep_disk_on_remove = "false" # Set to 'true' to not delete a disk on removal.
    start_iprange       = ""      # Leave blank for DHCP, else workers will be allocated range starting from this address
  }
}

variable "haproxy" {
  type = "map"

  default = {
    nodes               = "2"
    vcpu                = "2"
    memory              = "8192"
    disk_size           = ""      # Specify size or leave empty to use same size as template.
    thin_provisioned    = ""      # True or false. Whether to use thin provisioning on the disk. Leave blank to use same as template
    eagerly_scrub       = ""      # True or false. If set to true disk space is zeroed out on VM creation. Leave blank to use same as template
    keep_disk_on_remove = "false" # Set to 'true' to not delete a disk on removal.
    start_iprange       = ""      # Leave blank for DHCP, else masters will be allocated range starting from this address
  }
}

####################################
# RHN Registration
####################################
variable "rhn_username" {}

variable "rhn_password" {}
variable "rhn_poolid" {}

####################################
# DNS Registration & Certificates
####################################
variable "dnscerts" {
  default = "false"
}

variable "cloudflare_email" {}
variable "cloudflare_token" {}
variable "master_cname" {}
variable "app_cname" {}
variable "letsencrypt_email" {}

variable "letsencrypt_api_endpoint" {
  default = "https://acme-v02.api.letsencrypt.org/directory"
}

variable "letsencrypt_dns_provider" {}

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
  default = ""
}

variable "image_registry_password" {
  default = ""
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

variable "icp_admin_password" {
  default = "admin"
}
