data "aws_region" "current" {}

resource "aws_iam_instance_profile" "bastion" {
  name = "${var.loc_code}-iamip-${var.name}"
  role = "${aws_iam_role.bastion.name}"
}

resource "aws_iam_role" "bastion" {
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

resource "aws_security_group" "bastion" {
  name        = "${var.loc_code}-sg-${var.name}"
  description = "Allow all inbound traffic"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
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
  source = "git@github.com:lmickh/terraform-aws-modules.git//compute?ref=v1.1.0"

  ami                         = "${var.ami[data.aws_region.current.name]}"
  associate_public_ip_address = true
  ebs_optimized               = false
  instance_count              = "${var.instance_count}"
  key_name                    = "${var.ssh_key_name}"
  iam_instance_profile        = "${aws_iam_instance_profile.bastion.name}"
  instance_size               = "t2.medium"
  instance_config_data        = "${data.ignition_config.bastion.*.rendered}"
  loc_code                    = "${var.loc_code}"
  name                        = "${var.name}"
  subnet_ids                  = "${var.subnet_ids}"
  tags                        = "${var.tags}"
  vpc_security_group_ids      = ["${aws_security_group.bastion.id}"]
}

# resource "cloudflare_record" "bastion_host" {
#   count   = "${var.dns_cloudflare_records_enabled ? var.instance_count : 0}"
#   domain  = "${var.dns_zone}"
#   name    = "${var.loc_code}-${var.name}-${count.index}${var.dns_subdomain}"
#   value   = "${element(module.compute.public_ips, count.index)}"
#   type    = "${var.dns_cloudflare_record_type}"
#   ttl     = "${var.dns_record_ttl}"
#   proxied = "${var.dns_cloudflare_record_proxied}"
# }

