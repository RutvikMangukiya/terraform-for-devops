# 1. Finding the Index of a Value

variable "colors" {
  default = ["red", "green", "blue"]
}

output "index_of_green" {
  value = index(var.colors, "green")
}

# Output: 1

# "green" is located at index 1.
#-------------------------------

# 2. Value Not Found

output "index_of_yellow" {
  value = index(var.colors, "yellow")
}

# Error: The index function will throw an error because "yellow" isn't in the list.
# while calling index(list, value)
# var.colors is tuple with 3 elements
# Call to function "index" failed: item not found.