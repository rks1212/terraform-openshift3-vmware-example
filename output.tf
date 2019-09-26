# #################################################
# # Output Bastion Node
# #################################################
#


output "console" {
  value = "${var.master_cname}"
}

output "app_subdomain" {
  value = "${var.app_cname}"
}

output "username" {
  value = "admin"
}

output "password" {
  value = "admin"
}
