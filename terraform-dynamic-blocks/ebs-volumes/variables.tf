variable "ebs_volumes" {
    description = "List of EBS Volumes tp attach"
    type = list(object({
      device_name = string
      volume_size = number
    }))
    default = []
}