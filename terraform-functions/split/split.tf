# 1. Splitting a Comma-Separated String

variable "comma_separated" {
  default = "apple,orange,banana"
}

output "fruits_list" {
  value = split(",", var.comma_separated)
}

# Output: ["apple", "orange", "banana"]

# The split function converts the comma-separated string into a list of fruits.

# 2. Splitting a String with Spaces

variable "sentence" {
  default = "Terraform makes infrastructure simple"
}

output "words_list" {
  value = split(" ", var.sentence)
}

# Output: ["Terraform", "makes", "infrastructure", "simple"]

# Here, the split function breaks the sentence into individual words using a space as the delimiter.

# 3. Splitting with a Complex Delimiter

variable "complex_string" {
  default = "one#two#three#four"
}

output "split_result" {
  value = split("#", var.complex_string)
}

# Output: ["one", "two", "three", "four"]

# The split function uses "#" to separate the elements.

# 4. Splitting a String and Joining Again
# You can combine split and join for more complex manipulations:

variable "data" {
  default = "cat,dog,bird"
}

output "modified_animals" {
  value = join(" | ", split(",", var.data))
}

# Output: modified_animals = "cat | dog | bird"

# This example demonstrates splitting a comma-separated string into a list, then joining it back with " | " as the new delimiter.