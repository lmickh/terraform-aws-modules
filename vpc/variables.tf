variable "cidr_block" {
  default     = "10.0.0.0/16"
  type        = "string"
  description = "The CIDR block for the VPC."
}

variable "assign_generated_ipv6_cidr_block" {
  default     = false
  type        = "string"
  description = "The request amazon-provided IPv6 CIDR block."
}

variable "enable_classiclink" {
  default     = false
  type        = "string"
  description = "Allow VPC to link with class EC2 instances (non-VPC)."
}

variable "enable_classiclink_dns_support" {
  default     = false
  type        = "string"
  description = ""
}

variable "enable_dns_hostnames" {
  default     = false
  type        = "string"
  description = ""
}

variable "enable_dns_support" {
  default     = true
  type        = "string"
  description = "AWS provided DNS support within VPC."
}

variable "instance_tenancy" {
  default     = "default"
  type        = "string"
  description = "Tenancy for instances built in this VPC (i.e. default, dedicated, host)."
}

variable "loc_code" {
  type        = "string"
  description = "Location code - two letter geocode followed by int (Ex. am4 or ap10)."
}

variable "name" {
  default     = "vpc"
  type        = "string"
  description = ""
}

variable "tags" {
  default = {
    source = "terraform"
  }

  type = "map"
}
