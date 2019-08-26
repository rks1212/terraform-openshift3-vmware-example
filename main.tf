resource "random_id" "tag" {
  byte_length = 4
}

module "infrastructure" {
  source = "git::ssh://git@github.ibm.com/ncolon/terraform-openshift-vmware.git"

  # source                       = "../git/terraform-openshift-vmware"
  vsphere_server               = "${var.vsphere_server}"
  vsphere_cluster              = "${var.vsphere_cluster}"
  vsphere_datacenter           = "${var.vsphere_datacenter}"
  vsphere_resource_pool        = "${var.vsphere_resource_pool}"
  network_label                = "${var.network_label}"
  bastion_network_label        = "${var.bastion_network_label}"
  datastore                    = "${var.datastore}"
  template                     = "${var.template}"
  folder                       = "${var.hostname_prefix}"
  instance_name                = "${var.hostname_prefix}"
  domain                       = "${var.domain}"
  bastion_staticipblock        = "${var.bastion_staticipblock}"
  bastion_staticipblock_offset = "${var.bastion_staticipblock_offset}"
  bastion_gateway              = "${var.bastion_gateway}"
  bastion_netmask              = "${var.bastion_netmask}"
  bastion_dns_servers          = "${var.bastion_dns_servers}"
  staticipblock                = "${var.staticipblock}"
  staticipblock_offset         = "${var.staticipblock_offset}"
  gateway                      = "${var.gateway}"
  netmask                      = "${var.netmask}"
  dns_servers                  = "${var.dns_servers}"
  ssh_user                     = "${var.ssh_user}"
  ssh_password                 = "${var.ssh_password}"
  bastion_ssh_key_file         = "${var.bastion_ssh_key_file}"
  master                       = "${var.master}"
  infra                        = "${var.infra}"
  worker                       = "${var.worker}"
  storage                      = "${var.storage}"
  bastion                      = "${var.bastion}"
  haproxy                      = "${var.haproxy}"
}

locals {
  rhn_all_nodes = "${concat(
        "${list(module.infrastructure.bastion_public_ip)}",
        "${module.infrastructure.master_private_ip}",
        "${module.infrastructure.infra_private_ip}",
        "${module.infrastructure.app_private_ip}",
        "${module.infrastructure.storage_private_ip}",
        "${module.infrastructure.haproxy_public_ip}",
    )}"

  rhn_all_count = "${var.bastion["nodes"] + var.master["nodes"] + var.infra["nodes"] + var.worker["nodes"] + var.storage["nodes"] + var.haproxy["nodes"]}"
}

module "rhnregister" {
  source             = "git::ssh://git@github.ibm.com/ncolon/terraform-openshift-rhnregister.git"
  bastion_ip_address = "${module.infrastructure.bastion_public_ip}"
  private_ssh_key    = "${var.private_ssh_key}"
  ssh_username       = "${var.ssh_user}"
  rhn_username       = "${var.rhn_username}"
  rhn_password       = "${var.rhn_password}"
  rhn_poolid         = "${var.rhn_poolid}"
  all_nodes          = "${local.rhn_all_nodes}"
  all_count          = "${local.rhn_all_count}"
}

module "dnscerts" {
  source                   = "git::ssh://git@github.ibm.com/ncolon/terraform-openshift-dnscerts.git"
  dnscerts                 = "${var.dnscerts}"
  cloudflare_email         = "${var.cloudflare_email}"
  cloudflare_token         = "${var.cloudflare_token}"
  cloudflare_zone          = "${var.domain}"
  letsencrypt_email        = "${var.letsencrypt_email}"
  public_master_vip        = "${module.infrastructure.public_master_vip}"
  public_app_vip           = "${module.infrastructure.public_app_vip}"
  master_cname             = "${var.master_cname}-${random_id.tag.hex}"
  app_cname                = "${var.app_cname}-${random_id.tag.hex}"
  bastion_public_ip        = "${module.infrastructure.bastion_public_ip}"
  bastion_hostname         = "${module.infrastructure.bastion_hostname}"
  master_hostname          = "${module.infrastructure.master_hostname}"
  app_hostname             = "${module.infrastructure.app_hostname}"
  infra_hostname           = "${module.infrastructure.infra_hostname}"
  storage_hostname         = "${module.infrastructure.storage_hostname}"
  haproxy_hostname         = "${module.infrastructure.haproxy_hostname}"
  master_private_ip        = "${module.infrastructure.master_private_ip}"
  app_private_ip           = "${module.infrastructure.app_private_ip}"
  infra_private_ip         = "${module.infrastructure.infra_private_ip}"
  storage_private_ip       = "${module.infrastructure.storage_private_ip}"
  haproxy_public_ip        = "${module.infrastructure.haproxy_public_ip}"
  cloudflare_email         = "${var.cloudflare_email}"
  cloudflare_token         = "${var.cloudflare_token}"
  cluster_cname            = "${var.master_cname}-${random_id.tag.hex}.${var.domain}"
  app_subdomain            = "${var.app_cname}-${random_id.tag.hex}.${var.domain}"
  letsencrypt_dns_provider = "${var.letsencrypt_dns_provider}"
  letsencrypt_api_endpoint = "${var.letsencrypt_api_endpoint}"
  bastion_public_ip        = "${module.infrastructure.bastion_public_ip}"
  bastion_ssh_key_file     = "${var.private_ssh_key}"
  ssh_username             = "${var.ssh_user}"
  bastion                  = "${var.bastion}"
  master                   = "${var.master}"
  worker                   = "${var.worker}"
  infra                    = "${var.infra}"
  storage                  = "${var.storage}"
  haproxy                  = "${var.haproxy}"
}

module "openshift" {
  source = "git::ssh://git@github.ibm.com/ncolon/terraform-openshift-deploy.git"

  # source                  = "./terraform-openshift-deploy/"
  bastion_ip_address      = "${module.infrastructure.bastion_public_ip}"
  bastion_private_ssh_key = "${var.private_ssh_key}"
  master_private_ip       = "${module.infrastructure.master_private_ip}"
  infra_private_ip        = "${module.infrastructure.infra_private_ip}"
  app_private_ip          = "${module.infrastructure.app_private_ip}"
  storage_private_ip      = "${module.infrastructure.storage_private_ip}"
  bastion_hostname        = "${module.infrastructure.bastion_hostname}"
  master_hostname         = "${module.infrastructure.master_hostname}"
  infra_hostname          = "${module.infrastructure.infra_hostname}"
  app_hostname            = "${module.infrastructure.app_hostname}"
  storage_hostname        = "${module.infrastructure.storage_hostname}"
  haproxy_hostname        = "${module.infrastructure.haproxy_hostname}"
  domain                  = "${var.domain}"
  ssh_user                = "${var.ssh_user}"
  cloudprovider           = "${var.cloudprovider}"
  bastion                 = "${var.bastion}"
  master                  = "${var.master}"
  infra                   = "${var.infra}"
  worker                  = "${var.worker}"
  storage                 = "${var.storage}"
  ose_version             = "${var.ose_version}"
  ose_deployment_type     = "${var.ose_deployment_type}"
  image_registry          = "${var.image_registry}"
  image_registry_username = "${var.image_registry_username == "" ? var.rhn_username : ""}"
  image_registry_password = "${var.image_registry_password == "" ? var.rhn_password : ""}"
  master_cluster_hostname = "${module.infrastructure.public_master_vip}"
  cluster_public_hostname = "${var.master_cname}-${random_id.tag.hex}.${var.domain}"
  app_cluster_subdomain   = "${var.app_cname}-${random_id.tag.hex}.${var.domain}"
  registry_volume_size    = "${var.registry_volume_size}"
  dnscerts                = "${var.dnscerts}"
  haproxy                 = "${var.haproxy}"
  pod_network_cidr        = "${var.network_cidr}"
  service_network_cidr    = "${var.service_network_cidr}"
  host_subnet_length      = "${var.host_subnet_length}"
}

module "kubeconfig" {
  source = "git::ssh://git@github.ibm.com/ncolon/terraform-openshift-kubeconfig.git"

  # source                       = "../git/terraform-openshift-kubeconfig"
  bastion_ip_address      = "${module.infrastructure.bastion_public_ip}"
  bastion_private_ssh_key = "${var.private_ssh_key}"
  master_private_ip       = "${module.infrastructure.master_private_ip}"
  cluster_name            = "${var.hostname_prefix}-${random_id.tag.hex}"
  ssh_username            = "${var.ssh_user}"
}

module "installicp" {
  source = "../../git/terraform-openshift-installicp"

  # source             = "../../git/terraform-openshift-installicp"
  icp_binary         = "${var.icp_binary}"
  icp_install_path   = "${var.icp_install_path}"
  bastion_ip_address = "${module.infrastructure.bastion_public_ip}"
  ssh_user           = "${var.ssh_user}"
  private_ssh_key    = "${var.private_ssh_key}"
  worker             = "${var.worker}"
  worker_ip_address  = "${module.infrastructure.app_private_ip}"
  worker_hostname    = "${module.infrastructure.app_hostname}"
  master_ip_address  = "${module.infrastructure.master_private_ip}"
  master_hostname    = "${module.infrastructure.master_hostname}"
  domain             = "${var.domain}"
  app_subdomain      = "${var.app_cname}-${random_id.tag.hex}.${var.domain}"
  icp_admin_password = "${var.icp_admin_password}"
  storage_class      = "${var.storage_class}"
}

resource "random_string" "password" {
  length           = 16
  special          = true
  override_special = "/@\" "
}
