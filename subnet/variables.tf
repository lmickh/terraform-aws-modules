variable "assign_ipv6_address_on_creation" {
  default     = false
  description = "Indicate that network interfaces created in the specified subnet should be assigned an IPv6 address"
  type        = "string"
}

variable "cidr_block" {
  description = "CIDR block of the parent VPC.  Must be defined. (Ex. 10.11.0.0/16)"
  type        = "string"
}

variable "loc_code" {
  description = "Location code - two letter geocode followed by int (Ex. am4 or ap10). Must be defined."
  type        = "string"
}

variable "map_public_ip_on_launch" {
  default     = false
  description = "Indicate that network interfaces in this subnet shoudl be assigned public IPs"
  type        = "string"
}

variable "name" {
  description = "Used to form the Name tag"
  type        = "string"
}

variable "num_availability_zones" {
  description = "Number of AZs to build a subnet in"
  default     = 2
}

variable "route_table_associations" {
  default     = false
  description = "Whether to enable route table associations with subnet(s) created. "
}

variable "route_table_ids" {
  default     = []
  description = "Ordered list of table ids the subnets should be associated with."
  type        = "list"
}

variable "subnet_netnum" {
  description = "Starting network address number. Subsequent networks will increment."
  default     = 10
}

variable "subnet_offset" {
  description = "Offset bits from CIDR block to create subnet sizes"
  default     = 8
}

variable "tags" {
  default = {
    source = "terraform"
  }

  type = "map"
}

variable "vpc_id" {
  description = "ID of the VPC the subnet will be created in. Must be defined."
  type        = "string"
}
