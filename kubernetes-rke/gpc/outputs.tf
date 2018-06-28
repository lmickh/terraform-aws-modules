output "cluster" {
  value = "${var.kube_cluster_name}"
}

output "iam_role" {
  value = "${aws_iam_role.kubernetes_gpc.name}"
}

output "pool_dns_record" {
  value = "${var.loc_code}-${var.kube_cluster_name}${var.dns_subdomain}.${var.dns_zone}"
}

output "pool_labels" {
  value = {
    "example.com/node-pool"  = "${var.kube_pool_name}"
    "example.com/datacenter" = "${var.loc_code}"
    "example.com/region"     = "${data.aws_region.current.name}"
  }
}

output "pool_nodes" {
  value = "${zipmap(cloudflare_record.kubernetes_gpc_host.*.hostname, module.compute.private_ips)}"
}

output "pool_roles" {
  value = ["worker"]
}

output "pool_user" {
  value = "core"
}
