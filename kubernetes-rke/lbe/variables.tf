variable "dns_cloudflare_record_proxied" {
  default = false
}

variable "dns_cloudflare_record_type" {
  default = "A"
}

variable "dns_cloudflare_records_enabled" {
  default     = false
  description = "Enable the creation of A records for the VMs"
}

variable "dns_record_ttl" {
  default = "120"
}

variable "dns_subdomain" {
  default     = ""
  description = "Subdomain to be appended before the dns_zone when creating records i.e .dev"
  type        = "string"
}

variable "dns_zone" {
  default     = ""
  description = "DNS zone used to construction records for the instances"
  type        = "string"
}

variable "elb_logging_bucket" {
  description = "S3 bucket to put the load balancer access logs in"
  type        = "string"
}

variable "elb_subnet_ids" {
  description = "List of subnet ids to build the ELB in"
  type        = "list"
}

variable "ingress_cidrs" {
  default     = ["0.0.0.0/0"]
  description = "List of CIDRs to allow ssh ingress on"
  type        = "list"
}

variable "instance_count" {
  description = "Number of VMs to create"
  default     = 2
  type        = "string"
}

variable "instance_size" {
  description = "Size of VM instances"
  default     = "m5.large"
  type        = "string"
}

variable "kube_cluster_name" {
  description = "Cluster identifier"
  default     = "kube0"
  type        = "string"
}

variable "kube_pool_name" {
  description = "Node pool identifier"
  default     = "lbe"
  type        = "string"
}

variable "loc_code" {
  description = "Location code used to label the resources"
  type        = "string"
}

variable "num_availability_zones" {
  description = "Number of AZs to spread the VMs across"
  default     = 3
}

variable "subnet_ids" {
  description = "List of subnet ids the VMs will be placed in. "
  type        = "list"
}

variable "ssh_key_name" {
  description = "Name of the EC2 key pair that will be used on the VM."
  type        = "string"
}

variable "ssh_public_key_file" {
  description = "Path to the ssh public key to put on the server"
  type        = "string"
}

variable "tags" {
  default = {
    source = "terraform"
  }

  description = "A map of tag pairs to be applied to resources in the module"
  type        = "map"
}

variable "tf_role-id" {
  description = "Vault approle role-id used by script Terraform provides to fetch secrets. Should be set via ENVAR"
  type        = "string"
}

variable "tf_secret-id" {
  description = "Vault approle secret-id used by script Terraform provides to fetch secrets. Should be set via ENVAR"
  type        = "string"
}

variable "vault_addr" {
  default     = ""
  description = "Address of the Vault service to pull secrets from."
  type        = "string"
}

variable "vault_ssh_path" {
  description = "Path for the Vault ssh signer to manage sshd access"
  type        = "string"
}

variable "vpc_id" {
  type = "string"
}
