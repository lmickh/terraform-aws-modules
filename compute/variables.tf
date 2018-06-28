variable "ami" {}

variable "associate_public_ip_address" {
  default     = false
  description = "Associate a public IP with the VM within the vpc."
  type        = "string"
}

variable "disable_api_termination" {
  default = false
  type    = "string"
}

variable "ebs_optimized" {
  default = true
  type    = "string"
}

variable "iam_instance_profile" {
  default     = false
  description = "IAM profile to launch the instance attached to"
  type        = "string"
}

variable "instance_count" {
  default     = 1
  description = "Number of VMs to create"
  type        = "string"
}

variable "instance_size" {
  default     = "m5.large"
  description = "Instance type of the VM (t2.large, m5.large, etc)"
  type        = "string"
}

variable "instance_config_data" {
  default     = []
  description = "List of strings to be used as the custom user data"
  type        = "list"
}

variable "key_name" {
  description = "Name of the EC2 key pair used for ssh"
  type        = "string"
}

variable "loc_code" {
  description = "Location code - two letter geocode followed by int (Ex. am4 or ap10). Must be defined."
  type        = "string"
}

variable "monitoring" {
  default     = false
  description = "Enable detailed CloudWatch monitoring. Has nothing to do with other monitoring such as Datadog."
  type        = "string"
}

variable "name" {
  description = "Used to form the Name tag"
  type        = "string"
}

variable "num_availability_zones" {
  description = "Number of AZs to spread the VMs across"
  default     = 2
}

variable "placement_group_strategy" {
  default     = "spread"
  description = "Strategy of placement group for VMs (i.e. cluster or spread)"
  type        = "string"
}

variable "private_ips" {
  default     = []
  description = "List of private IPs to be assigned to the instances"
  type        = "list"
}

variable "storage_data_disk_count" {
  default     = 0
  description = "Number of data disks to attach to VM.  Must be 0-4."
  type        = "string"
}

variable "storage_data_disk_size" {
  default     = "30"
  description = "Size in GiBs of data disks"
  type        = "string"
}

variable "storage_data_disk_type" {
  default     = "gp2"
  description = "Type of EBS volume used as a data disk (gp2, io1, st1, sc1)"
  type        = "string"
}

variable "storage_os_delete_on_termination" {
  default     = true
  description = "Delete the OS/root device on instance termination"
  type        = "string"
}

variable "storage_os_disk_size" {
  default     = "30"
  description = "Size in GiBs of data disks"
  type        = "string"
}

variable "storage_os_disk_type" {
  default     = "gp2"
  description = "Type of EBS volume used as a data disk (gp2, io1, st1, sc1)"
  type        = "string"
}

variable "subnet_ids" {
  description = "List of subnet ids the VMs should be placed in"
  type        = "list"
}

variable "tags" {
  default = {
    source = "terraform"
  }

  type = "map"
}

variable "tenancy" {
  default     = "default"
  description = "Whether instance runs on shared or single-tennat hardware"
  type        = "string"
}

variable "vpc_security_group_ids" {
  default     = []
  description = "List of vpc security group ids to apply to the vm"
  type        = "list"
}
