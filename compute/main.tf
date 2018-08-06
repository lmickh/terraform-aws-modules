data "aws_availability_zones" "this" {}

data "aws_subnet" "this" {
  count = "${length(var.subnet_ids)}"
  id    = "${var.subnet_ids[count.index]}"
}

resource "aws_placement_group" "this" {
  name     = "${var.loc_code}-pg-${var.name}"
  strategy = "${var.placement_group_strategy}"
}

resource "aws_ebs_volume" "data0" {
  count             = "${var.storage_data_disk_count >= 1 ? var.instance_count : 0}"
  availability_zone = "${element(data.aws_subnet.this.*.availability_zone, count.index % var.num_availability_zones)}"
  size              = "${var.storage_data_disk_size}"
  type              = "${var.storage_data_disk_type}"
  tags              = "${merge(var.tags, map("Name", "${var.loc_code}-${var.name}-${count.index}-data0"))}"
}

resource "aws_volume_attachment" "data0" {
  count       = "${var.storage_data_disk_count >= 1 ? var.instance_count : 0}"
  device_name = "/dev/sdf"
  instance_id = "${element(aws_instance.this.*.id, count.index)}"
  volume_id   = "${element(aws_ebs_volume.data0.*.id, count.index)}"
}

resource "aws_ebs_volume" "data1" {
  count             = "${var.storage_data_disk_count >= 2 ? var.instance_count : 0}"
  availability_zone = "${element(data.aws_subnet.this.*.availability_zone, count.index % var.num_availability_zones)}"
  size              = "${var.storage_data_disk_size}"
  type              = "${var.storage_data_disk_type}"
  tags              = "${merge(var.tags, map("Name", "${var.loc_code}-${var.name}-${count.index}-data1"))}"
}

resource "aws_volume_attachment" "data1" {
  count       = "${var.storage_data_disk_count >= 2 ? var.instance_count : 0}"
  device_name = "/dev/sdg"
  instance_id = "${element(aws_instance.this.*.id, count.index)}"
  volume_id   = "${element(aws_ebs_volume.data0.*.id, count.index)}"
}

resource "aws_ebs_volume" "data2" {
  count             = "${var.storage_data_disk_count >= 3 ? var.instance_count : 0}"
  availability_zone = "${element(data.aws_subnet.this.*.availability_zone, count.index % var.num_availability_zones)}"
  size              = "${var.storage_data_disk_size}"
  type              = "${var.storage_data_disk_type}"
  tags              = "${merge(var.tags, map("Name", "${var.loc_code}-${var.name}-${count.index}-data2"))}"
}

resource "aws_volume_attachment" "data2" {
  count       = "${var.storage_data_disk_count >= 3 ? var.instance_count : 0}"
  device_name = "/dev/sdh"
  instance_id = "${element(aws_instance.this.*.id, count.index)}"
  volume_id   = "${element(aws_ebs_volume.data0.*.id, count.index)}"
}

resource "aws_ebs_volume" "data3" {
  count             = "${var.storage_data_disk_count >= 4 ? var.instance_count : 0}"
  availability_zone = "${element(data.aws_subnet.this.*.availability_zone, count.index % var.num_availability_zones)}"
  size              = "${var.storage_data_disk_size}"
  type              = "${var.storage_data_disk_type}"
  tags              = "${merge(var.tags, map("Name", "${var.loc_code}-${var.name}-${count.index}-data3"))}"
}

resource "aws_volume_attachment" "data3" {
  count       = "${var.storage_data_disk_count >= 4 ? var.instance_count : 0}"
  device_name = "/dev/sdi"
  instance_id = "${element(aws_instance.this.*.id, count.index)}"
  volume_id   = "${element(aws_ebs_volume.data0.*.id, count.index)}"
}

resource "aws_instance" "this" {
  count                       = "${var.instance_count}"
  ami                         = "${var.ami}"
  associate_public_ip_address = "${var.associate_public_ip_address}"
  availability_zone           = "${element(data.aws_subnet.this.*.availability_zone, count.index % var.num_availability_zones)}"
  disable_api_termination     = "${var.disable_api_termination}"
  ebs_optimized               = "${lookup(local.ebs_optimized, var.instance_size, var.ebs_optimized)}"
  iam_instance_profile        = "${var.iam_instance_profile}"
  instance_type               = "${var.instance_size}"
  key_name                    = "${var.key_name}"
  monitoring                  = "${var.monitoring}"
  placement_group             = "${aws_placement_group.this.id}"
  private_ip                  = "${length(var.private_ips) > 0 ? element(concat(var.private_ips, list("")), count.index) : ""}"
  subnet_id                   = "${element(var.subnet_ids, count.index % var.num_availability_zones)}"
  tenancy                     = "${var.tenancy}"
  user_data_base64            = "${length(var.instance_config_data) > 0 ? base64encode(element(concat(var.instance_config_data, list("")), count.index)) : base64encode("") }"
  vpc_security_group_ids      = ["${var.vpc_security_group_ids}"]

  root_block_device {
    delete_on_termination = "${var.storage_os_delete_on_termination}"
    volume_size           = "${var.storage_os_disk_size}"
    volume_type           = "${var.storage_os_disk_type}"
  }

  tags = "${merge(var.tags, map("Name", "${var.loc_code}-${var.name}-${count.index}"))}"
}
