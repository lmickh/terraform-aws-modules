output "cidr_block" {
  value = "${aws_vpc.main.cidr_block}"
}

output "default_network_acl_id" {
  value = "${aws_vpc.main.default_network_acl_id}"
}

output "default_security_group_id" {
  value = "${aws_vpc.main.default_security_group_id}"
}

output "default_route_table_id" {
  value = "${aws_vpc.main.default_route_table_id}"
}

output "id" {
  value = "${aws_vpc.main.id}"
}

output "instance_tenancy" {
  value = "${aws_vpc.main.instance_tenancy}"
}

output "main_route_table_id" {
  value = "${aws_vpc.main.main_route_table_id}"
}
