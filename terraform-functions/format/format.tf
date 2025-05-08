# 1. Formatting Strings

variable "first_name" {
  default = "Eren"
}

variable "last_name" {
  default = "Mikasa"
}

output "formatted_name" {
  value = format("Full Name: %s %s", var.first_name, var.last_name)
}

# Output: "Full Name: Eren Mikasa"
###################################################################

# 2. Formatting Integers

variable "age" {
  default = 30
}

output "formatted_age" {
  value = format("Age: %d years", var.age)
}

# Output: "Age: 30 years"
###################################################################

# 3. Formatting floats

variable "price" {
  default = 25.6789
}

output "formatted_price" {
  value = format("Total Price: %.2f USD", var.price)
}

# Output: "Total Price: 25.68 USD"
###################################################################

# 4. Boolean Values

variable "is_active" {
  default = true
}

output "status_message" {
  value = format("Status: %t", var.is_active)
}

# Output: "Status: true"
###################################################################

# 5. Using Automatic Formatting with %v

variable "items" {
  default = [1, "apple", 3.14, true]
}

output "mixed_output" {
  value = format("Values: %v", var.items)
}

# Output: "Values: [1 apple 3.14 true]"