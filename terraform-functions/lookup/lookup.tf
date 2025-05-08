# 1. Retrieving a Value from a Map

variable "region_settings" {
  default = {
    us-east-1 = "Virginia"
    us-west-1 = "California"
  }
}

output "selected_region" {
  value = lookup(var.region_settings, "us-east-1", "Unknown")
}

# Output: selected_region = "Virginia"

# The lookup function retrieves the value for the key "us-east-1" from the map region_settings.
##########################################################################################################

# 2. Using a Default Value When the Key Is Missing

output "undefined_region" {
  value = lookup(var.region_settings, "eu-central-1", "Unknown")
}

# Output: undefined_region = "Unknown"

# Since "eu-central-1" does not exist in the map, the lookup function returns the default value "Unknown".
##########################################################################################################

#3. Nested lookup Example

variable "settings" {
  default = {
    database = {
      host = "db.example.com"
      port = 5432
    }
  }
}

output "database_host" {
  value = lookup(var.settings["database"], "host", "localhost")
}

# Output: database_host = "db.example.com"

# The lookup function accesses nested map values efficiently.