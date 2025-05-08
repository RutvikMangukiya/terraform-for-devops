# 1. Joining a List of Strings

variable "languages" {
  default = ["Go", "Python", "Java"]
}

output "joined_languages" {
  value = join(", ", var.languages)
}

# Output: joined_languages = "Go, Python, Java"

# The join function combines the list into a single string, using ", " as the separator.
########################################################################################

# 2. Joining with No Delimeter

variable "letters" {
  default = ["a", "b", "c"]
}

output "combined_letters" {
  value = join("", var.letters)
}

# Output: combined_letters = "abc"

# The join function combines all elements with no space between them.
########################################################################################

# 3. Joining Integers (Converted to Strings)
# Although join directly works with strings, you can convert integers to strings before joining them:

variable "numbers" {
  default = ["1", "2", "3"]
}

output "joined_numbers" {
  value = join("-", var.numbers)
}

# Output: joined_numbers = "1-2-3"

# This example demonstrates that if numbers are already strings, you can join them seamlessly using "-" as a delimiter.