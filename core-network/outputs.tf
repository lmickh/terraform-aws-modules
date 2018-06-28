output "cidr_block" {
  value = "${var.cidr_block}"
}

output "dns_subdomain" {
  value = "${var.dns_subdomain}"
}

output "dns_zone" {
  value = "${var.dns_zone}"
}

output "loc_code" {
  value = "${var.loc_code}"
}

output "region" {
  value = "${data.aws_region.current.name}"
}

output "route_table_ids_private" {
  value = "${aws_route_table.private.*.id}"
}

output "route_table_public" {
  value = "${aws_route_table.public.id}"
}

output "public_subnet_ids" {
  value = "${module.public.ids}"
}

output "subnet_offset" {
  value = "${var.subnet_offset}"
}

output "vpc_id" {
  value = "${module.vpc.id}"
}
