# Network Interface / Attach / EC2 / EBS / Attach

# Network Interface
resource "aws_network_interface" "nic" {
	for_each = var.nic_info
	subnet_id = each.value.subnet_id[each.value.subnet_id_idx]
	private_ips = [each.value.private_ip]
	security_groups = [each.value.sg_id]
}

# EBS
resource "aws_ebs_volume" "ebs" {
	for_each = var.ebs_info
	availability_zone = each.value.az
	type = each.value.storage_type
	size = each.value.storage_size
	tags = {
		Name = each.value.storage_name
	}
	# encrypted = "true"
	# kms_key_id = each.value.kms_arn
}

# EC2
resource "aws_instance" "ec2" {
	for_each = var.ec2
	ami = each.value.ami
	availability_zone = each.value.az

	instance_type = each.value.ec2_type
	key_name = each.value.key_name
	root_block_device {
		volume_type = each.value.os_volume_type
		volume_size = each.value.os_volume_size
		tags = {
			Name = each.value.os_volume_name
		}
		# encrypted = each.value.encrypted
		# kms_key_id = each.value.kms_arn
		delete_on_termination = false
	}
    network_interface {
      network_interface_id = aws_network_interface.nic["nic_1"].id
      device_index = 0
    }
	user_data = <<-EOF
		#!/bin/bash
		${each.value.script}
	EOF

	tags = {
		Name = each.value.ec2_name
	}
}

# Network Interface Attachment
resource "aws_network_interface_attachment" "nic_attachment" {
	for_each = var.nic_attachment_info
	instance_id = each.value.nic_ec2_id[each.value.nic_attachment_ec2_idx]
	network_interface_id = each.value.nic_id[each.value.nic_attachment_nic_idx]
	device_index = each.value.nic_index
}

# EBS Attachment
resource "aws_volume_attachment" "ebs_attachment" {
	for_each = var.ebs_attachment
	force_detach = each.value.force_detach
	device_name = each.value.device_name
	volume_id = each.value.ebs_id[each.value.ebs_attachment_ebs_idx]
	instance_id = each.value.ebs_ec2_id[each.value.ebs_attachment_ec2_idx]
}

