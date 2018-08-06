output "security_group_id" {
  description = "ID for the security group attached to the bastion instance."
  value       = "${aws_security_group.bastion.id}"
}
