# 1. Removing Duplicates

variable "numbers" {
  default = [1,2,2,2,3,4,4,5]
}

output "unique_numbers" {
    value = distinct(var.numbers)
}

# Output: [1, 2, 3, 4, 5]

# The distinct function removes the duplicate 2 and 4 values.

#################################################################

# 2. Handling Lists with All Unique Elements

variable "unique_list" {
  default = ["apple", "banana", "cherry"]
}

output "still_unique" {
  value = distinct(var.unique_list)
}

# Output: ["apple", "banana", "cherry"]

# The list remains unchanged as all elements are already unique.