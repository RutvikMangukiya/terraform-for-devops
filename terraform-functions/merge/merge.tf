# 1. Merging Two Maps

variable "default_config" {
  default = {
    environment   = "dev"
    instance_type = "t2.micro"
  }
}

variable "override_config" {
  default = {
    instance_type = "t3.small"
    region        = "us-west-2"
  }
}

output "final_config" {
  value = merge(var.default_config, var.override_config)
}

# Output: {
# final_config = {
#   "environment" = "dev"
#   "instance_type" = "t3.small"
#   "region" = "us-west-2"
# }

# The merge function combines default_config and override_config, with override_config taking precedence in case of conflicting keys.
##############################################################################################################################################

# 2. Merging Multiple Maps

variable "map1" {
  default = {
    a = 1
    b = 2
  }
}

variable "map2" {
  default = {
    b = 3
    c = 4
  }
}

variable "map3" {
  default = {
    c = 5
    d = 6
  }
}

output "combined_map" {
  value = merge(var.map1, var.map2, var.map3)
}

# Output: 
# combined_map = {
#   "a" = 1
#   "b" = 3
#   "c" = 5
#   "d" = 6
# }

# The merge function combines all three maps, with later maps (map2 and map3) taking precedence over earlier ones in case of overlapping keys.
##############################################################################################################################################

# 3. Using merge with Nested Maps

variable "base_settings" {
  default = {
    database = {
      host = "db.local"
      port = 3306
    }
  }
}

variable "additional_settings" {
  default = {
    database = {
      user     = "admin"
      password = "secret"
    }
  }
}

output "merged_settings" {
  value = merge(var.base_settings["database"], var.additional_settings["database"])
}

# Output: 
# merged_settings = {
#   "host" = "db.local"
#   "password" = "secret"
#   "port" = 3306
#   "user" = "admin"
# }

# The merge function combines the nested maps under the database key, creating a more complete configuration.