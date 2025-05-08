# 1. Finding the Length of a List

variable "colors" {
  default = ["red", "green", "blue"]
}

output "colors_count" {
  value = length(var.colors)
}

# Output: colors_count = 3

# The length function counts the number of elements in the list colors.
#############################################################################

# 2. Determining the Length of a Map
variable "person" {
  default = {
    name   = "Alice"
    age    = 30
    gender = "female"
  }
}

output "person_attributes" {
  value = length(var.person)
}

# Output: person_attributes = 3

# The length function counts the number of key-value pairs in the map person.
#############################################################################

#3. Calculating the Length of a String
variable "welcome_message" {
  default = "Hello, Terraform!"
}

output "message_length" {
  value = length(var.welcome_message)
}

#Output: message_length = 17

#The length function returns the total number of characters in the string, including spaces and punctuation.