variable "nic_info" {
	type = map(object({
		subnet_id = any
		private_ip = string
		sg_id = string
		subnet_id_idx = number
	}))
}

variable "ebs_info" {
	type = map(object({
		az = string
		storage_type = string
		storage_size = number
		storage_name = string
		# kms_arn = string
	}))
}

variable "ec2" {
	type = map(object({
		ami            = string
		az             = string

		ec2_type       = string
		key_name       = string
		script         = optional(string, "")

		ec2_name       = string
		os_volume_type = string
		os_volume_size = number
		os_volume_name = string
		# encrypted      = bool
		# kms_arn        = string
	}))
}

variable "nic_attachment_info" {
	type = map(object({
		nic_ec2_id = any
		nic_id = any
		nic_index = number
		nic_attachment_ec2_idx = number
		nic_attachment_nic_idx = number
	}))
}


variable "ebs_attachment" {
	type = map(object({
		force_detach = bool
		device_name = string
		ebs_id = any
		ebs_ec2_id = any
		ebs_attachment_ebs_idx = number
		ebs_attachment_ec2_idx = number
	}))
}
