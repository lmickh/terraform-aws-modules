resource "aws_security_group" "kubernetes_ctl_elb" {
  name        = "${var.loc_code}-sg-lb-${var.kube_cluster_name}-ctl"
  description = "Kubernetes control plane external ELB sg"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = "${merge(var.tags, map("Name", "${var.loc_code}-sg-lb-${var.kube_cluster_name}-ctl"))}"
}

resource "aws_elb" "kubernetes_ctl" {
  name                      = "${var.loc_code}-lb-${var.kube_cluster_name}-ctl"
  cross_zone_load_balancing = true
  idle_timeout              = 60
  instances                 = ["${module.compute.ids}"]
  internal                  = false
  security_groups           = ["${aws_security_group.kubernetes_ctl_elb.id}"]
  subnets                   = ["${var.elb_subnet_ids}"]

  access_logs {
    bucket        = "${var.elb_logging_bucket}"
    bucket_prefix = "elb/${var.loc_code}-lb-${var.kube_cluster_name}-ctl"
    interval      = 60
  }

  listener {
    instance_port     = 6443
    instance_protocol = "tcp"
    lb_port           = 443
    lb_protocol       = "tcp"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTPS:8080/healthz"
    interval            = 30
  }

  tags = "${merge(var.tags, map("Name", "${var.loc_code}-lb-${var.kube_cluster_name}-ctl"))}"
}
