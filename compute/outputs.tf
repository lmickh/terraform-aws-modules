output "loc_code" {
  value = "${var.loc_code}"
}

output "ids" {
  value = "${aws_instance.main.*.id}"
}

output "volume_ids" {
  value = "${aws_volume_attachment.data0.*.volume_id}"
}

output "device_name" {
  value = "${aws_volume_attachment.data0.*.device_name}"
}

output "public_ips" {
  value = "${aws_instance.main.*.public_ip}"
}

output "private_ips" {
  value = "${aws_instance.main.*.private_ip}"
}

output "key_name" {
  value = "${aws_instance.main.*.key_name}"
}
