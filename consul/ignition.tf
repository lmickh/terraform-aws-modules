module "ignition_docker" {
  source = "git@github.com:lmickh/terraform-ignition-modules.git//docker?ref=v1.0.0"

  docker_opts = "--log-opt max-size=500m --log-opt max-file=3"
}

module "ignition_locksmithd" {
  source = "git@github.com:lmickh/terraform-ignition-modules.git//locksmithd?ref=v1.0.0"
}

module "ignition_sshd" {
  source = "git@github.com:lmickh/terraform-ignition-modules.git//sshd?ref=v1.0.0"
}

module "ignition_sysctl" {
  source = "git@github.com:lmickh/terraform-ignition-modules.git//sysctl?ref=v1.0.0"
}

module "ignition_ulimits" {
  source = "git@github.com:lmickh/terraform-ignition-modules.git//ulimits?ref=v1.0.0"
}

data "ignition_config" "consul" {
  count = "${var.instance_count}"

  files = [
    "${element(data.ignition_file.hostname.*.id, count.index)}",
    "${module.ignition_docker.file_dockeropts_id}",
    "${module.ignition_sshd.file_sshd_config_id}",
    "${module.ignition_sysctl.file_sysctl_id}",
    "${module.ignition_ulimits.file_ulimits_id}",
  ]

  systemd = [
    "${module.ignition_locksmithd.systemd_locksmithd_id}",
  ]

  users = ["${data.ignition_user.core.id}"]
}

data "ignition_file" "hostname" {
  count      = "${var.instance_count}"
  filesystem = "root"
  path       = "/etc/hostname"
  mode       = "420"

  content {
    content = "${var.loc_code}-${var.name}-${count.index}"
  }
}

data "ignition_user" "core" {
  name = "core"

  #  ssh_authorized_keys = ["${file(var.ssh_public_key_file)}"]
}
