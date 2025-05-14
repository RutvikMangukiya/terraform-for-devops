# 1. Basic Coalescelist Usage

variable "list1" {
  default = []
}

variable "list2" {
  default = ["apple", "banana"]
}

output "first_non_empty_list" {
  value = coalescelist(var.list1, var.list2, ["fallback"])
}

# Output: first_non_empty_list = ["apple", "banana"]

# The function returns list2 as it is the first non-empty list.
###############################################################

# 2. All Lists Empty

variable "empty_list1" {
  default = []
}

variable "empty_list2" {
  default = []
}

output "all_empty_lists" {
  value = coalescelist(var.empty_list1, var.empty_list2, ["All_Empty_List"])
}

# Output: all_empty_lists = ["All_Empty_List"]

# Since all lists are empty, the result is an empty list.