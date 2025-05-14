# 1. Basic Coalesce Usage

variable "var1" {
  default = null
}

variable "var2" {
  default = "default_something"
}

output "first_non_null" {
  value = coalesce(var.var1, var.var2, "fallback_value")
}

# Output: first_non_null = "default_something"

# The function returns var2 because it is the first non-null value.
###################################################################

# 2. All Values Null

variable "var3" {
  default = null
}

output "all_null" {
  value = coalesce(var.var1, var.var3, "All_Null")
}

# Output: all_null = "All_Null"

# Since all values are null, the result is null.