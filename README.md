# terraform-openshift3-vmware-example

End to end example of deploying Openshift on VMware. In this example we use the following sub-modules:

* [terraform-openshift3-infra-vmware](https://github.com/ibm-cloud-architecture/terraform-openshift3-infra-vmware) - To create VMs on VMware.
* [terraform-openshift-rhnregister](https://github.com/ibm-cloud-architecture/terraform-openshift-rhnregister) - To register all VMs with Red Hat Network subscriptions.
* [terraform-lb-haproxy-vmware](https://github.com/ibm-cloud-architecture/terraform-lb-haproxy-vmware) - To create two HAProxy load balancers (one for the console, one for the application router).
* [terraform-dns-rfc2136](https://github.com/ibm-cloud-architecture/terraform-dns-rfc2136) - To update our private network DNS server with all required records on the internal network.
* [terraform-dns-cloudflare](https://github.com/ibm-cloud-architecture/terraform-dns-cloudflare) - To create CNAME records on cloudflare to get to the console and applications from our external network.
* [terraform-certs-letsencrypt-cloudflare](https://github.com/ibm-cloud-architecture/terraform-certs-letsencrypt-cloudflare) - To generate certs from LetsEncrypt for our console and router
* [terraform-openshift3-deploy](https://github.com/ibm-cloud-architecture/terraform-openshift3-deploy) - To generate the ansible inventory file and deploy Openshift.

Before deploying, you will need to set the following environment variables:

```bash
export VSPHERE_USER=<user>
export VSPHERE_PASSWORD=<password>

export CLOUDFLARE_EMAIL=<cloudflare email>
export CLOUDFLARE_TOKEN=<cloudflare api key>
export CLOUDFLARE_API_KEY=<cloudflare api key>
```

Use the following commands to deploy:

```bash
terraform init
terraform apply 
```

## Example

Example `terraform.tfvars` file.  We provision an HA Openshift cluster.

```terraform
#######################################
##### vSphere Access Credentials ######
#######################################
vsphere_server = "vsphere-server.my-domain.com"

# Set username/password as environment variables VSPHERE_USER and VSPHERE_PASSWORD

# SSH username and private key to connect to VM template, has passwordless sudo access
ssh_user = "virtuser"
ssh_private_key_file = "~/.ssh/id_rsa"

##############################################
##### vSphere deployment specifications ######
##############################################
# Following resources must exist in vSphere
vsphere_datacenter = "dc01"
vsphere_cluster = "cluster01"
vsphere_resource_pool = "jkwong-ocp3"
datastore_cluster = "dc01-ocp-cluster"
template = "rhel-7.6-template"

# vSphere Folder to provision the new VMs in, will be created
folder = "terraform_jkwong_ocp"

# MUST consist of only lower case alphanumeric characters and '-'
hostname_prefix = "jkwong-ocp"

# it's best to use a service account for these
image_registry_username = "<registry.redhat.io service account username>"
image_registry_password = "<registry.redhat.io service acocunt password>"

rhn_username = "<rhn username>"
rhn_password = "<rhn password>"
rhn_poolid = "<rhn pool id>"

##### Network #####
private_network_label = "private_network"
private_staticipblock = "192.168.101.0/24"
private_staticipblock_offset = 10           # IP assignment starts at 192.168.101.11
private_netmask = "24"
private_gateway = "192.168.101.1"
private_domain = "internal-network.local"
private_dns_servers = [ "192.168.101.2" ]

public_network_label = "external_network"
public_staticipblock = "10.30.65.0/24"
public_staticipblock_offset = 30            # ips - [ 10.30.65.31, 10.30.65.32, 10.30.65.33 ]
public_netmask = "24"
public_gateway = "10.30.65.1"
public_domain = "my-public-domain.com"
public_dns_servers = [ "1.1.1.1" ]

# for the private network DNS
dns_key_name = "rndc-key."
dns_key_algorithm = "hmac-md5"
dns_key_secret = "<blahblahblah>"
dns_record_ttl = 300

# will add these to cloudflare domain, but it's going to be pointing at internal IPs
master_cname = "ocp-console.my-public-domain.com"
app_cname = "ocp-apps.my-public-domain.com"

# for letsencrypt cert generation with DNS01 challenge using cloudflare
letsencrypt_email = "jkwong@ca.ibm.com"
letsencrypt_dns_provider = "cloudflare"
letsencrypt_api_endpoint="https://acme-v02.api.letsencrypt.org/directory"

# node definitions
master = {
    nodes = "3"
    vcpu = "8"
    memory = "16384"

    disk_size = "100"
    docker_disk_size = "100"
    thin_provisioned = "true"
    keep_disk_on_remove = false
    eagerly_scrub = false
}

infra = {
    nodes = "3"
    vcpu = "8"
    memory = "32768"

    disk_size = "100"
    docker_disk_size = "100"
    thin_provisioned = "true"
    keep_disk_on_remove = false
    eagerly_scrub = false
}

worker = {
    nodes = "3"
    vcpu = "8"
    memory = "32768"

    disk_size = "100"
    docker_disk_size = "100"
    thin_provisioned = "true"
    keep_disk_on_remove = false
    eagerly_scrub = false
}

storage = {
    nodes = "3"
    vcpu = "4"
    memory = "16384"

    disk_size = "100"
    docker_disk_size = "100"
    gluster_disk_size = "200"
    thin_provisioned = "true"
    keep_disk_on_remove = false
    eagerly_scrub = false
}
```
