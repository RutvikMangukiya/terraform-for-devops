# 1. Flattening a Simple Nested List

variable "nested_list" {
  default = [["a", "b"], ["c", "d"], ["e"]]
}

output "flat_list" {
  value = flatten(var.nested_list)
}

# Output: ["a", "b", "c", "d", "e"]

# The flatten function removes the inner list structure, resulting in a single-level list.
##########################################################################################

# 2. Flattening Lists with Empty Lists

variable "mixed_nested_list" {
  default = [["apple", "banana"], [], ["cherry"]]
}

output "flattened_result" {
  value = flatten(var.mixed_nested_list)
}

# Output: ["apple", "banana", "cherry"]

# Empty lists within the nested list are ignored, resulting in a flat list.
##########################################################################################

# 3. Flattening Multiple Levels of Nesting

variable "deep_nested_list" {
  default = [[[1, 2], [-1, -2]], [3, 4], [5]]
}

output "flat_deep_list" {
  value = flatten(flatten(var.deep_nested_list))
}

# Output: [1, 2, 3, 4, 5]

# Applying flatten multiple times can help when there are multiple levels of nesting.