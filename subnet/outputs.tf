output "availability_zones" {
  value = "${aws_subnet.main.*.availability_zone}"
}

output "cidr_blocks" {
  value = "${aws_subnet.main.*.cidr_block}"
}

output "ids" {
  value = "${aws_subnet.main.*.id}"
}

output "vpc_id" {
  value = "${var.vpc_id}"
}
