# Extracting Keys

variable "server_config" {
  default = {
    instance_type = "t2.micro"
    region        = "us-east-1"
    availability  = "zone-a"
  }
}

output "config_keys" {
  value = keys(var.server_config)
}

# Output: config_keys = ["instance_type", "region", "availability"]

# This returns all the keys from the server_config map as a list.

output "config_values" {
  value = values(var.server_config)
}

# Output: config_values = ["t2.micro", "us-east-1", "zone-a"]

# This returns all the values from the server_config map as a list.