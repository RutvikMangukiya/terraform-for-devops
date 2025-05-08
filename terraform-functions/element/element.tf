# 1. Basic Element Access

variable "fruit_list" {
  default = ["apple", "banana", "cherry"]
}

output "second_element" {
  value = element(var.fruit_list, 1)
}

# Output: second_element = "banana"

# The element at index 1 in the list is "banana".
#################################################

# 2. Accessing Out-of-Bounds Index

output "wrapped_index" {
  value = element(var.fruit_list, 4)
}

# Output: wrapped_index = "banana"

# Index 4 wraps around to 1 (4 % 3 = 1).