# 1. Slicing a List from Index 1 to 3

variable "numbers" {
  default = [10, 20, 30, 40, 50]
}

output "sliced_list" {
  value = slice(var.numbers, 1, 3)
}

# Output: sliced_list = [20, 30]

# The slice function extracts elements from index 1 to 3 (excluding 3).
#######################################################################

# 2. Slicing to the End of a List

output "slice_to_end" {
  value = slice(var.numbers, 2, length(var.numbers))
}

# Output: slice_to_end = [30, 40, 50]

# Using length(var.numbers) as the end index slices the list up to the last element.