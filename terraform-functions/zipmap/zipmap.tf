# 1. Creating a Simple Map

variable "keys" {
  default = ["name", "age", "city"]
}

variable "values" {
  default = ["Alice", 30, "New York"]
}

output "person_map" {
  value = zipmap(var.keys, var.values)
}

# Output: {
# "name" = "Alice"
# "age" = 30
# "city" = "New York"
# }

# The zipmap function combines keys and values into a map.
#############################################################################################

# 2. Handling Lists of Different Lengths
# If the keys list is longer than the values list, zipmap fills the missing values with null.

variable "keys_extra" {
  default = ["one", "two", "three", "four"]
}

variable "values_short" {
  default = [1, 2]
}

output "mismatched_zipmap" {
  value = zipmap(var.keys_extra, var.values_short)
}

# Error: Error in function call
# while calling zipmap(keys, values)
# var.keys_extra is tuple with 4 elements
# var.values_short is tuple with 2 elements
# Call to function "zipmap" failed: number of keys (4) does not match number of values (2).

# Expected Output: {
# "one" = 1
# "two" = 2
# "three" = null
# "four" = null
# }

# The additional keys are paired with null values.
#############################################################################################

# 3. Using zipmap with Computed Values

variable "countries" {
  default = ["USA", "Canada", "Mexico"]
}

variable "codes" {
  default = ["USA", "CA", "MX"]
}

output "country_code_map" {
  value = zipmap(var.countries, var.codes)
}

# Output: {
# "USA" = "US"
# "Canada" = "CA"
# "Mexico" = "MX"
# }

# The zipmap function efficiently maps country names to their respective codes.