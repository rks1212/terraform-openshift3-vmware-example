
# to get certs from letsencrypt, using cloudflare as a DNS01 challenge

#module "certs" {
#    source                   = "github.com/ibm-cloud-architecture/terraform-certs-letsencrypt-cloudflare?ref=v1.0"
#
#    cloudflare_email         = "${var.cloudflare_email}"
#    cloudflare_token         = "${var.cloudflare_token}"
#    letsencrypt_email        = "${var.letsencrypt_email}"
#
#    cluster_cname            = "${var.master_cname}"
#    app_subdomain            = "${var.app_cname}"
#}
