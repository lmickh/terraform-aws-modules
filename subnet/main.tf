data "aws_availability_zones" "main" {}

resource "aws_subnet" "main" {
  count                           = "${var.num_availability_zones}"
  cidr_block                      = "${cidrsubnet(var.cidr_block, var.subnet_offset, var.subnet_netnum + count.index)}"
  assign_ipv6_address_on_creation = "${var.assign_ipv6_address_on_creation}"
  availability_zone               = "${element(data.aws_availability_zones.main.names, count.index)}"
  map_public_ip_on_launch         = "${var.map_public_ip_on_launch}"
  vpc_id                          = "${var.vpc_id}"

  tags = "${merge(var.tags, map("Name", "${var.loc_code}-subnet-${var.name}-${count.index}"))}"
}

resource "aws_route_table_association" "main" {
  count          = "${var.route_table_associations ? var.num_availability_zones : 0}"
  subnet_id      = "${element(aws_subnet.main.*.id, count.index)}"
  route_table_id = "${element(var.route_table_ids, count.index)}"
}
