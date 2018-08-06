data "aws_region" "current" {}

resource "aws_iam_instance_profile" "consul" {
  name = "${var.loc_code}-iamip-${var.name}"
  role = "${aws_iam_role.consul.name}"
}

resource "aws_iam_role" "consul" {
  name = "${var.loc_code}-iamr-${var.name}"
  path = "/"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}

resource "aws_security_group" "consul" {
  name        = "${var.loc_code}-sg-${var.name}"
  description = "Allow all inbound traffic"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = "${var.ingress_cidrs}"
  }

  # DNS
  ingress {
    from_port   = 53
    to_port     = 53
    protocol    = "tcp"
    cidr_blocks = "${var.ingress_cidrs}"
  }

  ingress {
    from_port   = 53
    to_port     = 53
    protocol    = "udp"
    cidr_blocks = "${var.ingress_cidrs}"
  }

  # consul server RPC
  ingress {
    from_port   = 8300
    to_port     = 8300
    protocol    = "tcp"
    cidr_blocks = "${var.ingress_cidrs}"
  }

  # consul serf lan
  ingress {
    from_port   = 8301
    to_port     = 8301
    protocol    = "tcp"
    cidr_blocks = "${var.ingress_cidrs}"
  }

  ingress {
    from_port   = 8301
    to_port     = 8301
    protocol    = "udp"
    cidr_blocks = "${var.ingress_cidrs}"
  }

  # consul serf wan
  ingress {
    from_port   = 8302
    to_port     = 8302
    protocol    = "tcp"
    cidr_blocks = "${var.ingress_cidrs}"
  }

  ingress {
    from_port   = 8302
    to_port     = 8302
    protocol    = "udp"
    cidr_blocks = "${var.ingress_cidrs}"
  }

  # consul http(s) api
  ingress {
    from_port   = 8500
    to_port     = 8501
    protocol    = "tcp"
    cidr_blocks = "${var.ingress_cidrs}"
  }

  # consul dns 
  ingress {
    from_port   = 8600
    to_port     = 8600
    protocol    = "tcp"
    cidr_blocks = "${var.ingress_cidrs}"
  }

  ingress {
    from_port   = 8600
    to_port     = 8600
    protocol    = "udp"
    cidr_blocks = "${var.ingress_cidrs}"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = "${merge(var.tags, map("Name", "${var.loc_code}-sg-${var.name}"))}"
}

module "compute" {
  source = "git@github.com:lmickh/terraform-aws-modules.git//compute?ref=v1.2.0"

  ami                     = "${var.ami[data.aws_region.current.name]}"
  instance_count          = "${var.instance_count}"
  key_name                = "${var.ssh_key_name}"
  iam_instance_profile    = "${aws_iam_instance_profile.consul.name}"
  instance_size           = "${var.instance_size}"
  instance_config_data    = "${data.ignition_config.consul.*.rendered}"
  loc_code                = "${var.loc_code}"
  name                    = "${var.name}"
  storage_data_disk_count = "1"
  storage_data_disk_size  = "${var.storage_data_disk_size}"
  subnet_ids              = "${var.subnet_ids}"
  tags                    = "${var.tags}"
  vpc_security_group_ids  = ["${aws_security_group.consul.id}"]
}

resource "aws_route53_record" "consul_host" {
  count   = "${var.dns_route53_records_enabled ? var.instance_count : 0}"
  zone_id = "${var.dns_route53_zone_id}"
  name    = "${var.loc_code}-${var.name}-${count.index}"
  type    = "A"
  ttl     = "360"

  records = ["${module.compute.private_ips[count.index]}"]
}

resource "aws_route53_record" "consul_cluster" {
  count   = "${var.dns_route53_records_enabled ? 1 : 0}"
  zone_id = "${var.dns_route53_zone_id}"
  name    = "${var.loc_code}-${var.name}"
  type    = "A"
  ttl     = "360"

  records = ["${module.compute.private_ips}"]
}
