variable "compartment_ocid" {}
variable "tenancy_ocid" {}
variable "user_ocid" {}
variable "fingerprint" {}
variable "private_key_path" {}
variable "public_key_path" {}
variable "availability_domain" {}
variable "my_public_ip_cidr" {}
variable "cluster_name" {}
variable "certmanager_email_address" {}
variable "region" {
  type = string
}
variable "k3s_server_pool_size" {
  default = 1
}
variable "k3s_worker_pool_size" {
  default = 2
}
variable "k3s_extra_worker_node" {
  default = false
}
variable "expose_kubeapi" {
  default = false
}
variable "environment" {
  default = "staging"
}
variable "ingress_controller" {}

variable "install_longhorn" {
  type    = bool
  default = false
}

variable "install_argocd" {
  type    = bool
  default = true
}

variable "install_oci_ccm" {
  type        = bool
  default     = false
  description = "Install OCI CCM to manage storage and load balancers."
}

variable "ccm_release" {
  type    = string
  default = "v1.25.1"
}

module "k3s_cluster" {
  # k3s_version               = "v1.23.8+k3s2" # Fix kubectl exec failure
  # k3s_version               = "v1.24.4+k3s1" # Kubernetes version compatible with longhorn
  region                    = var.region
  availability_domain       = var.availability_domain
  tenancy_ocid              = var.tenancy_ocid
  compartment_ocid          = var.compartment_ocid
  my_public_ip_cidr         = var.my_public_ip_cidr
  cluster_name              = var.cluster_name
  public_key_path           = var.public_key_path
  environment               = var.environment
  certmanager_email_address = var.certmanager_email_address
  k3s_server_pool_size      = var.k3s_server_pool_size
  k3s_worker_pool_size      = var.k3s_worker_pool_size
  k3s_extra_worker_node     = var.k3s_extra_worker_node
  expose_kubeapi            = var.expose_kubeapi
  source                    = "../"
  ingress_controller        = var.ingress_controller
  install_longhorn          = var.install_longhorn
  install_argocd            = var.install_argocd
  install_oci_ccm           = var.install_oci_ccm
  ccm_release               = var.ccm_release
}

output "k3s_servers_ips" {
  value = module.k3s_cluster.k3s_servers_ips
}

output "k3s_workers_ips" {
  value = module.k3s_cluster.k3s_workers_ips
}

output "public_lb_ip" {
  value = module.k3s_cluster.public_lb_ip
}
