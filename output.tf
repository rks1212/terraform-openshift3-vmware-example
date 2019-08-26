# #################################################
# # Output Bastion Node
# #################################################
#
output "bastion_public_ip" {
  value = "${module.infrastructure.bastion_public_ip}"
}

output "bastion_hostname" {
  value = "${module.infrastructure.bastion_hostname}"
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
  value = "${module.infrastructure.app_private_ip}"
}

output "worker_hostname" {
  value = "${module.infrastructure.app_hostname}"
}

output "storage_private_ip" {
  value = "${module.infrastructure.storage_private_ip}"
}

output "storage_hostname" {
  value = "${module.infrastructure.storage_hostname}"
}

output "haproxy_public_ip" {
  value = "${module.infrastructure.haproxy_public_ip}"
}

output "haproxy_hostname" {
  value = "${module.infrastructure.haproxy_hostname}"
}

output "console" {
  value = "console.${var.app_cname}-${random_id.tag.hex}.${var.domain}"
}

output "username" {
  value = "admin"
}

output "password" {
  value = "admin"
}

output "kubeconfig" {
  value = "${module.kubeconfig.config}"
}
