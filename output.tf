output "ec2_id" {
	value = [for i in aws_instance.ec2 : i.id]
}

output "nic_id" {
	value = [for i in aws_network_interface.nic : i.id]
}

output "ebs_id" {
	value = [for i in aws_ebs_volume.ebs : i.id]
}
