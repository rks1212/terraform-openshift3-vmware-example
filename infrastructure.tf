provider "vsphere" {
  version        = "~> 1.1"
  vsphere_server = "${var.vsphere_server}"

  # if you have a self-signed cert
  allow_unverified_ssl = "${var.vsphere_allow_unverified_ssl}"
}

##################################
#### Collect resource IDs
##################################
data "vsphere_datacenter" "dc" {
  name = "${var.vsphere_datacenter}"
}

data "vsphere_compute_cluster" "cluster" {
  name          = "${var.vsphere_cluster}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_datastore" "datastore" {
  count = "${var.datastore != "" ? 1 : 0}"

  name          = "${var.datastore}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_datastore_cluster" "datastore_cluster" {
  count = "${var.datastore_cluster != "" ? 1 : 0}"

  name          = "${var.datastore_cluster}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_resource_pool" "pool" {
  name          = "${var.vsphere_cluster}/Resources/${var.vsphere_resource_pool}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_network" "private_network" {
  name          = "${var.private_network_label}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_network" "public_network" {
  count         = "${var.public_network_label != "" ? 1 : 0}"
  name          = "${var.public_network_label}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

# Create a folder
resource "vsphere_folder" "ocpenv" {
  count = "${var.folder != "" ? 1 : 0}"
  path = "${var.folder}"
  type = "vm"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

locals  {
  folder_path = "${var.folder != "" ?
        element(concat(vsphere_folder.ocpenv.*.path, list("")), 0)
        : ""}"
}

module "infrastructure" {
  source                       = "github.com/ibm-cloud-architecture/terraform-openshift3-infra-vmware"

  # vsphere information
  vsphere_server               = "${var.vsphere_server}"
  vsphere_cluster_id           = "${data.vsphere_compute_cluster.cluster.id}"
  vsphere_datacenter_id        = "${data.vsphere_datacenter.dc.id}"
  vsphere_resource_pool_id     = "${data.vsphere_resource_pool.pool.id}"
  private_network_id           = "${data.vsphere_network.private_network.id}"
  public_network_id            = "${var.public_network_label != "" ? data.vsphere_network.public_network.0.id : ""}"
  datastore_id                 = "${var.datastore != "" ? data.vsphere_datastore.datastore.0.id : ""}"
  datastore_cluster_id         = "${var.datastore_cluster != "" ? data.vsphere_datastore_cluster.datastore_cluster.0.id : ""}"
  folder_path                  = "${local.folder_path}"

  instance_name                = "${var.hostname_prefix}-${random_id.tag.hex}"

  public_staticipblock         = "${var.public_staticipblock}"
  public_staticipblock_offset  = "${var.public_staticipblock_offset}"
  public_gateway               = "${var.public_gateway}"
  public_netmask               = "${var.public_netmask}"
  public_domain                = "${var.public_domain}"
  public_dns_servers           = "${var.public_dns_servers}"

  bastion_ip_address           = "${var.bastion_private_ip}"
  master_ip_address            = "${var.master_private_ip}"
  worker_ip_address            = "${var.worker_private_ip}"
  infra_ip_address             = "${var.infra_private_ip}"
  storage_ip_address           = "${var.storage_private_ip}"
  
  private_staticipblock        = "${var.private_staticipblock}"
  private_staticipblock_offset = "${var.private_staticipblock_offset}"
  private_netmask              = "${var.private_netmask}"
  private_gateway              = "${var.private_gateway}"
  private_domain               = "${var.private_domain}"
  private_dns_servers          = "${var.private_dns_servers}"

  # how to ssh into the template
  template                     = "${var.template}"
  template_ssh_user            = "${var.ssh_user}"
  template_ssh_password        = "${var.ssh_password}"
  template_ssh_private_key     = "${file(var.ssh_private_key_file)}"

  # the keys to be added between bastion host and the VMs
  ssh_private_key              = "${tls_private_key.installkey.private_key_pem}"
  ssh_public_key               = "${tls_private_key.installkey.public_key_openssh}"

  # information about VM types
  master                       = "${var.master}"
  infra                        = "${var.infra}"
  worker                       = "${var.worker}"
  storage                      = "${var.storage}"
  bastion                      = "${var.bastion}"
}

output "bastion_public_ip" {
  value = "${module.infrastructure.bastion_public_ip}"
}

output "bastion_hostname" {
  value = "${module.infrastructure.bastion_hostname}"
}

output "bastion_private_ip" {
  value = "${module.infrastructure.bastion_private_ip}"
}

output "master_private_ip" {
  value = "${module.infrastructure.master_private_ip}"
}

output "master_hostname" {
  value = "${module.infrastructure.master_hostname}"
}

output "infra_private_ip" {
  value = "${module.infrastructure.infra_private_ip}"
}

output "infra_hostname" {
  value = "${module.infrastructure.infra_hostname}"
}

output "worker_private_ip" {
  value = "${module.infrastructure.worker_private_ip}"
}

output "worker_hostname" {
  value = "${module.infrastructure.worker_hostname}"
}

output "storage_private_ip" {
  value = "${module.infrastructure.storage_private_ip}"
}

output "storage_hostname" {
  value = "${module.infrastructure.storage_hostname}"
}
