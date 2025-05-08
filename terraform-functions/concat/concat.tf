# 1. Concatenating Two Lists

variable "list1" {
  default = ["apple", "banana", "cherry"]
}

variable "list2" {
  default = ["cherry", "date"]
}

output "combined_list" {
  value = concat(var.list1, var.list2)
}

# Output: ["apple", "banana", "cherry", "cherry", "date"]

# The concat function combines list1 and list2 into a single list.
###################################################################################

# 2. Concatenating with an Empty List

variable "empty_list" {
  default = []
}

variable "fruits" {
  default = ["grape", "orange"]
}

output "result_list" {
  value = concat(var.empty_list, var.fruits)
}

# Output: ["grape", "orange"]

# Concatenating an empty list with another list results in just the non-empty list.
###################################################################################

# 3. Concatenating Multiple Lists

variable "list_a" {
  default = ["one", "two"]
}

variable "list_b" {
  default = ["three"]
}

variable "list_c" {
  default = ["four", "five"]
}

output "combined_multiple_lists" {
  value = concat(var.list_a, var.list_b, var.list_c)
}

# Output: ["one", "two", "three", "four", "five"]

# Multiple lists are combined into one ordered list.