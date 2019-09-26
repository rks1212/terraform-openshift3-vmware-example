resource "random_id" "tag" {
  byte_length = 4
}

resource "tls_private_key" "installkey" {
  algorithm = "RSA"
  rsa_bits = "2048"
}



locals {
  rhn_all_nodes = "${concat(
        "${list(module.infrastructure.bastion_public_ip)}",
        "${module.infrastructure.master_private_ip}",
        "${module.infrastructure.infra_private_ip}",
        "${module.infrastructure.worker_private_ip}",
        "${module.infrastructure.storage_private_ip}"
    )}"

  rhn_all_count = "${lookup(var.bastion, "nodes", "1") + lookup(var.master, "nodes", "1") + lookup(var.infra, "nodes", "1") + lookup(var.worker, "nodes", "3") + lookup(var.storage, "nodes", "3")}"
  openshift_node_count = "${lookup(var.master, "nodes", "1") + lookup(var.worker, "nodes", "3") + lookup(var.infra, "nodes", "1") +  lookup(var.storage, "nodes", "3")}"
}

module "rhnregister" {
  source             = "github.com/ibm-cloud-architecture/terraform-openshift-rhnregister.git"

  bastion_ip_address      = "${module.infrastructure.bastion_public_ip}"
  bastion_ssh_user        = "${var.ssh_user}"
  bastion_ssh_password    = "${var.ssh_password}"
  bastion_ssh_private_key = "${file(var.ssh_private_key_file)}"

  ssh_user           = "${var.ssh_user}"
  ssh_password       = "${var.ssh_password}"
  ssh_private_key    = "${tls_private_key.installkey.private_key_pem}"

  rhn_username       = "${var.rhn_username}"
  rhn_password       = "${var.rhn_password}"
  rhn_poolid         = "${var.rhn_poolid}"
  all_nodes          = "${local.rhn_all_nodes}"
  all_count          = "${local.rhn_all_count}"
}

module "openshift" {
  source = "github.com/ibm-cloud-architecture/terraform-openshift3-deploy"

  dependson = [
    "${module.rhnregister.registered_resource}",
    "${module.etchosts.module_completed}"
  ]

  # cluster nodes
  node_count              = "${local.openshift_node_count}"
  master_count            = "${lookup(var.master, "nodes", "1")}"
  infra_count             = "${lookup(var.infra, "nodes", "1")}"
  worker_count            = "${lookup(var.worker, "nodes", "3")}"
  storage_count           = "${lookup(var.storage, "nodes", "3")}"

  master_private_ip       = "${module.infrastructure.master_private_ip}"
  infra_private_ip        = "${module.infrastructure.infra_private_ip}"
  worker_private_ip       = "${module.infrastructure.worker_private_ip}"
  storage_private_ip      = "${module.infrastructure.storage_private_ip}"
  master_hostname         = "${formatlist("%v.%v", module.infrastructure.master_hostname, var.private_domain)}"
  infra_hostname          = "${formatlist("%v.%v", module.infrastructure.infra_hostname, var.private_domain)}"
  worker_hostname         = "${formatlist("%v.%v", module.infrastructure.worker_hostname, var.private_domain)}"
  storage_hostname        = "${formatlist("%v.%v", module.infrastructure.storage_hostname, var.private_domain)}"

  # second disk is docker block device, in VMware it's /dev/sdb
  docker_block_device     = "/dev/sdb"
  
  # third disk on storage nodes, in VMware it's /dev/sdc
  gluster_block_devices   = ["/dev/sdc"]

  # connection parameters
  bastion_ip_address      = "${module.infrastructure.bastion_public_ip}"
  bastion_ssh_user        = "${var.ssh_user}"
  bastion_ssh_password    = "${var.ssh_password}"
  bastion_ssh_private_key = "${file(var.ssh_private_key_file)}"

  ssh_user                = "${var.ssh_user}"
  ssh_private_key         = "${tls_private_key.installkey.private_key_pem}"

  cloudprovider           = {
      kind = "vsphere"
  }

  ose_version             = "${var.ose_version}"
  ose_deployment_type     = "${var.ose_deployment_type}"
  image_registry          = "${var.image_registry}"
  image_registry_username = "${var.image_registry_username == "" ? var.rhn_username : var.image_registry_username}"
  image_registry_password = "${var.image_registry_password == "" ? var.rhn_password : var.image_registry_password}"

  # internal API endpoint -- private IP of load balancer
  master_cluster_hostname = "${module.console_loadbalancer.node_hostname}.${var.private_domain}"

  # public endpoints - must be in DNS
  cluster_public_hostname = "${var.master_cname}"
  app_cluster_subdomain   = "${var.app_cname}"

  registry_volume_size    = "${var.registry_volume_size}"

  pod_network_cidr        = "${var.network_cidr}"
  service_network_cidr    = "${var.service_network_cidr}"
  host_subnet_length      = "${var.host_subnet_length}"

  storageclass_file       = "${var.storage_class}"
  storageclass_block      = "${var.storage_class}"

  custom_inventory = [
    "openshift_storage_glusterfs_storageclass_default=false",
    "openshift_hosted_registry_storage_kind=vsphere",
    "openshift_hosted_registry_storage_access_modes=['ReadWriteOnce']",
    "openshift_hosted_registry_storage_annotations=['volume.beta.kubernetes.io/storage-provisioner: kubernetes.io/vsphere-volume']",
    "openshift_hosted_registry_replicas=1",
    "openshift_cloudprovider_kind=vsphere",
    "openshift_cloudprovider_vsphere_username=${var.vsphere_storage_username}",
    "openshift_cloudprovider_vsphere_password=${var.vsphere_storage_password}",
    "openshift_cloudprovider_vsphere_host=${var.vsphere_server}",
    "openshift_cloudprovider_vsphere_datacenter=${var.vsphere_datacenter}",
    "openshift_cloudprovider_vsphere_cluster=${var.vsphere_cluster}",
    "openshift_cloudprovider_vsphere_resource_pool=${var.vsphere_resource_pool}",
    "openshift_cloudprovider_vsphere_datastore=${var.vsphere_storage_datastore}",
    "openshift_cloudprovider_vsphere_folder=${var.folder}",
    "openshift_cloudprovider_vsphere_network=${var.private_network_label}"
  ]

#  master_cert             = "${module.certs.master_cert}"
#  master_key              = "${module.certs.master_key}"
#  router_cert             = "${module.certs.router_cert}"
#  router_key              = "${module.certs.router_key}"
#  router_ca_cert          = "${module.certs.ca_cert}"
}