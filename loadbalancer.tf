module "console_loadbalancer" {
    source                  = "github.com/ibm-cloud-architecture/terraform-lb-haproxy-vmware.git"

    vsphere_server                = "${var.vsphere_server}"
    vsphere_allow_unverified_ssl  = "${var.vsphere_allow_unverified_ssl}"
    
    vsphere_datacenter_id     = "${data.vsphere_datacenter.dc.id}"
    vsphere_cluster_id        = "${data.vsphere_compute_cluster.cluster.id}"
    vsphere_resource_pool_id  = "${data.vsphere_resource_pool.pool.id}"
    datastore_id              = "${var.datastore != "" ? data.vsphere_datastore.datastore.0.id : ""}"
    datastore_cluster_id      = "${var.datastore_cluster != "" ? data.vsphere_datastore_cluster.datastore_cluster.0.id : ""}"

    # Folder to provision the new VMs in, does not need to exist in vSphere
    folder_path               = "${local.folder_path}"
    instance_name             = "${var.hostname_prefix}-${random_id.tag.hex}-console"

    private_network_id = "${data.vsphere_network.private_network.id}"
    private_ip_address = "${cidrhost(var.private_staticipblock, var.private_staticipblock_offset + lookup(var.bastion, "nodes", "1") + lookup(var.master, "nodes", "1") + lookup(var.infra, "nodes", "1") + lookup(var.worker, "nodes", "1") + lookup(var.storage, "nodes", "1") + 1)}"
    private_netmask = "${var.private_netmask}"
    private_gateway = "${var.private_gateway}"
    private_domain               = "${var.private_domain}"

    public_network_id = "${var.public_network_label != "" ? data.vsphere_network.public_network.0.id : ""}"
    public_ip_address = "${var.public_network_label != "" ? cidrhost(var.public_staticipblock, var.public_staticipblock_offset + lookup(var.bastion, "nodes", "1") + 1) : ""}"
    public_netmask = "${var.public_network_label != "" ? var.public_netmask: ""}"
    public_gateway = "${var.public_network_label != "" ? var.public_gateway : ""}"
    public_domain               = "${var.public_domain}"

    dns_servers = compact(concat(var.public_dns_servers, var.private_dns_servers))

    # how to ssh into the template
    template                         = "${var.template}"
    template_ssh_user                = "${var.ssh_user}"
    template_ssh_password            = "${var.ssh_password}"
    template_ssh_private_key         = "${file(var.ssh_private_key_file)}"


    bastion_ip_address      = "${module.infrastructure.bastion_public_ip}"

    frontend = ["443"]
    backend = {
        "443" = "${join(",", module.infrastructure.master_private_ip)}"
    }
}

module "app_loadbalancer" {
    source                  = "github.com/ibm-cloud-architecture/terraform-lb-haproxy-vmware.git"

    vsphere_server                = "${var.vsphere_server}"
    vsphere_allow_unverified_ssl  = "${var.vsphere_allow_unverified_ssl}"
    
    vsphere_datacenter_id     = "${data.vsphere_datacenter.dc.id}"
    vsphere_cluster_id        = "${data.vsphere_compute_cluster.cluster.id}"
    vsphere_resource_pool_id  = "${data.vsphere_resource_pool.pool.id}"
    datastore_id              = "${var.datastore != "" ? data.vsphere_datastore.datastore.0.id : ""}"
    datastore_cluster_id      = "${var.datastore_cluster != "" ? data.vsphere_datastore_cluster.datastore_cluster.0.id : ""}"

    # Folder to provision the new VMs in, does not need to exist in vSphere
    folder_path               = "${local.folder_path}"
    instance_name             = "${var.hostname_prefix}-${random_id.tag.hex}-app"

    private_network_id  = "${data.vsphere_network.private_network.id}"
    private_ip_address  = "${cidrhost(var.private_staticipblock, var.private_staticipblock_offset + lookup(var.bastion, "nodes", "1") + lookup(var.master, "nodes", "1") + lookup(var.infra, "nodes", "1") + lookup(var.worker, "nodes", "3") + lookup(var.storage, "nodes", "3") + 2)}"
    private_netmask     = "${var.private_netmask}"
    private_gateway     = "${var.private_gateway}"
    private_domain      = "${var.private_domain}"

    public_network_id   = "${var.public_network_label != "" ? data.vsphere_network.public_network.0.id : ""}"
    public_ip_address   = "${var.public_network_label != "" ? cidrhost(var.public_staticipblock, var.public_staticipblock_offset + lookup(var.bastion, "nodes", "1") + 2) : ""}"
    public_netmask      = "${var.public_network_label != "" ? var.public_netmask : ""}"
    public_gateway      = "${var.public_network_label != "" ? var.public_gateway : ""}"
    public_domain       = "${var.public_domain}"

    dns_servers = compact(concat(var.public_dns_servers, var.private_dns_servers))

    # how to ssh into the template
    template                         = "${var.template}"
    template_ssh_user                = "${var.ssh_user}"
    template_ssh_password            = "${var.ssh_password}"
    template_ssh_private_key         = "${file(var.ssh_private_key_file)}"

    bastion_ip_address      = "${module.infrastructure.bastion_public_ip}"

    frontend = ["80", "443"]
    backend = {
        "443" = "${join(",", module.infrastructure.infra_private_ip)}"
        "80" = "${join(",", module.infrastructure.infra_private_ip)}"
    }
}

output "console_lb_hostname" {
  value = "${module.console_loadbalancer.node_hostname}"
}

output "console_lb_private_ip" {
  value = "${module.console_loadbalancer.node_private_ip}"
}

output "console_lb_public_ip" {
  value = "${module.console_loadbalancer.node_public_ip}"
}

output "app_lb_hostname" {
  value = "${module.app_loadbalancer.node_hostname}"
}

output "app_lb_private_ip" {
  value = "${module.app_loadbalancer.node_private_ip}"
}

output "app_lb_public_ip" {
  value = "${module.app_loadbalancer.node_public_ip}"
}
