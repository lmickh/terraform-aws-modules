data "aws_region" "current" {}

module "vpc" {
  source = "git@github.com:lmickh/terraform-aws-modules.git//vpc?ref=v1.0.0"

  assign_generated_ipv6_cidr_block = "${var.vpc_assign_generated_ipv6_cidr_block}"
  cidr_block                       = "${var.cidr_block}"
  enable_classiclink               = "${var.vpc_enable_classiclink}"
  enable_classiclink_dns_support   = "${var.vpc_enable_classiclink_dns_support}"
  enable_dns_hostnames             = "${var.vpc_enable_dns_hostnames}"
  enable_dns_support               = "${var.vpc_enable_dns_support}"
  instance_tenancy                 = "${var.vpc_instance_tenancy}"
  loc_code                         = "${var.loc_code}"
  tags                             = "${var.tags}"
}

resource "aws_internet_gateway" "main" {
  vpc_id = "${module.vpc.id}"
  tags   = "${merge(var.tags, map("Name", "${var.loc_code}-igw"))}"
}

resource "aws_egress_only_internet_gateway" "main" {
  vpc_id = "${module.vpc.id}"
}

module "public" {
  source = "git@github.com:lmickh/terraform-aws-modules.git//subnet?ref=v1.0.0"

  cidr_block               = "${var.cidr_block}"
  loc_code                 = "${var.loc_code}"
  name                     = "public"
  num_availability_zones   = "${var.num_availability_zones}"
  route_table_associations = true
  route_table_ids          = "${list(aws_route_table.public.id, aws_route_table.public.id, aws_route_table.public.id)}"
  subnet_offset            = "${var.subnet_offset}"
  subnet_netnum            = 0
  vpc_id                   = "${module.vpc.id}"

  tags = "${var.tags}"
}

# Normally I would separate EIPs out, but because you cannot reassign the EIP 
# without rebuilding the nat gateway it is kind of pointless.
resource "aws_eip" "ngw" {
  count = "${var.num_availability_zones}"
  vpc   = true
  tags  = "${var.tags}"
}

resource "aws_nat_gateway" "main" {
  count         = "${var.num_availability_zones}"
  allocation_id = "${element(aws_eip.ngw.*.id, count.index)}"
  subnet_id     = "${element(module.public.ids, count.index)}"
  tags          = "${merge(var.tags, map("Name", "${var.loc_code}-ngw-${count.index}"))}"
}

resource "aws_route_table" "public" {
  vpc_id = "${module.vpc.id}"
  tags   = "${merge(var.tags, map("Name", "${var.loc_code}-rtb-public"))}"
}

resource "aws_route" "public-igw" {
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.main.id}"
  route_table_id         = "${aws_route_table.public.id}"
}

resource "aws_route" "public-igw-ipv6" {
  destination_ipv6_cidr_block = "::/0"
  gateway_id                  = "${aws_internet_gateway.main.id}"
  route_table_id              = "${aws_route_table.public.id}"
}

resource "aws_route_table" "private" {
  count  = "${var.num_availability_zones}"
  vpc_id = "${module.vpc.id}"
  tags   = "${merge(var.tags, map("Name", "${var.loc_code}-rtb-private-${count.index}"))}"
}

resource "aws_route" "private-nat" {
  count                  = "${var.num_availability_zones}"
  route_table_id         = "${element(aws_route_table.private.*.id, count.index)}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = "${element(aws_nat_gateway.main.*.id, count.index)}"
}

resource "aws_route" "private-eogw-ipv6" {
  count                       = "${ var.vpc_assign_generated_ipv6_cidr_block ? var.num_availability_zones : 0 }"
  route_table_id              = "${element(aws_route_table.private.*.id, count.index)}"
  destination_ipv6_cidr_block = "::/0"
  egress_only_gateway_id      = "${aws_egress_only_internet_gateway.main.id}"
}

resource "aws_main_route_table_association" "private" {
  vpc_id         = "${module.vpc.id}"
  route_table_id = "${aws_route_table.private.0.id}"
}
