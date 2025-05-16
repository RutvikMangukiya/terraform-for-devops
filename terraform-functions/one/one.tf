# 1. Basic One Usage

variable "single_value" {
  default = [only_value]
}

output "exactly_one_non_null" {
  value = one([var.single_value, null])
}

# Output: "only_value"

# The function returns single_value because it is the only non-null value.
#-------------------------------------------------------------------------------

# 2. More than One Non-Null

variable "var4" {
    default = "value_1"
}

variable "var5" {
    default = "value_2"
}

output "more_than_one_non_null" {
    value = one(var.var4, var.var5)
}

# Error: The function will throw an error because there are two non-null values.
#-------------------------------------------------------------------------------

# 3. No Non-Null Values
output "no_non_null" {
  value = one(null, null)
}

# Error: The function will throw an error because there are no non-null values.