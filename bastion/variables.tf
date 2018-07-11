variable "ami" {
  default = {
    "us-east-1" = "ami-f6ecac89"
    "us-east-2" = "ami-5bf4ca3e"
  }
}

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

variable "ingress_cidrs" {
  default     = ["0.0.0.0/0"]
  description = "List of CIDRs to allow ssh ingress on"
  type        = "list"
}

variable "instance_count" {
  default = 1
}

variable "loc_code" {
  description = "Location code used to label the resources"
  type        = "string"
}

variable "name" {
  default = "bastion"
  type    = "string"
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

variable "vpc_id" {
  type = "string"
}
