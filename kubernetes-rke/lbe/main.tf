data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

resource "aws_iam_instance_profile" "kubernetes_lbe" {
  name = "${var.loc_code}-iamip-${var.kube_cluster_name}-${var.kube_pool_name}"
  role = "${aws_iam_role.kubernetes_lbe.name}"
}

resource "aws_iam_role" "kubernetes_lbe" {
  name = "${var.loc_code}-iamr-${var.kube_cluster_name}-${var.kube_pool_name}"
  path = "/"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": [
          "ec2.amazonaws.com"
        ]
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_policy" "kubernetes_lbe" {
  name        = "${var.loc_code}-iamp-${var.kube_cluster_name}-${var.kube_pool_name}"
  description = "${var.loc_code}-${var.kube_cluster_name}-${var.kube_pool_name} policy"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ec2:AttachVolume",
                "ec2:Describe*",
                "ec2:DetachVolume",
                "iam:PassRole"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "kubernetes_lbe" {
  role       = "${aws_iam_role.kubernetes_lbe.name}"
  policy_arn = "${aws_iam_policy.kubernetes_lbe.arn}"
}

resource "aws_security_group" "kubernetes_lbe" {
  name        = "${var.loc_code}-sg-${var.kube_cluster_name}-${var.kube_pool_name}"
  description = "Allow all inbound traffic"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.ingress_cidrs}"]
  }

  # http(s) for ingress controller
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["${var.ingress_cidrs}"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["${var.ingress_cidrs}"]
  }

  # etcd
  ingress {
    from_port   = 2379
    to_port     = 2380
    protocol    = "tcp"
    cidr_blocks = ["${var.ingress_cidrs}"]
  }

  # flannel vxlan
  ingress {
    from_port   = 8472
    to_port     = 8472
    protocol    = "tcp"
    cidr_blocks = ["${var.ingress_cidrs}"]
  }

  # kubernetes 
  ingress {
    from_port   = 10250
    to_port     = 10256
    protocol    = "tcp"
    cidr_blocks = ["${var.ingress_cidrs}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = "${merge(var.tags, map("Name", "${var.loc_code}-sg-${var.kube_cluster_name}-${var.kube_pool_name}"))}"
}

module "compute" {
  source = "git@github.com:lmickh/terraform-aws-modules.git//compute?ref=v1.0.0"

  ami                    = "ami-5d6e5e38"
  ebs_optimized          = true
  instance_count         = "${var.instance_count}"
  key_name               = "${var.ssh_key_name}"
  iam_instance_profile   = "${aws_iam_instance_profile.kubernetes_lbe.name}"
  loc_code               = "${var.loc_code}"
  name                   = "${var.kube_cluster_name}-${var.kube_pool_name}"
  num_availability_zones = "${var.num_availability_zones}"
  subnet_ids             = "${var.subnet_ids}"
  instance_count         = "${var.instance_count}"
  instance_size          = "${var.instance_size}"
  instance_config_data   = "${data.ignition_config.kubernetes_lbe.*.rendered}"
  vpc_security_group_ids = ["${aws_security_group.kubernetes_lbe.id}"]
}

resource "cloudflare_record" "kubernetes_lbe_host" {
  count   = "${var.dns_cloudflare_records_enabled ? var.instance_count : 0}"
  domain  = "${var.dns_zone}"
  name    = "${var.loc_code}-${var.kube_cluster_name}-${var.kube_pool_name}-${count.index}${var.dns_subdomain}"
  value   = "${element(module.compute.private_ips, count.index)}"
  type    = "${var.dns_cloudflare_record_type}"
  ttl     = "${var.dns_record_ttl}"
  proxied = "${var.dns_cloudflare_record_proxied}"
}

resource "cloudflare_record" "kubernetes_lbe_service" {
  domain  = "${var.dns_zone}"
  name    = "${var.loc_code}-${var.kube_cluster_name}-${var.kube_pool_name}${var.dns_subdomain}"
  value   = "${aws_elb.kubernetes_lbe.dns_name}"
  type    = "CNAME"
  ttl     = "${var.dns_record_ttl}"
  proxied = "${var.dns_cloudflare_record_proxied}"
}