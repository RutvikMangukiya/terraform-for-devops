# 1. Formatting a List of Strings

variable "cities" {
    default = ["New York", "Los Angles", "Chicago"]
}

output "city_greetings" {
    value = formatlist("Welcome to %s!", var.cities)
}

# Output: ["Welcome to New York!", "Welcome to Los Angeles!", "Welcome to Chicago!"]
####################################################################################

# 2. Formatting a List on Integers 

variable "scores" {
    default = [95, 85, 75]
}

output "formatted_scores" {
    value = formatlist("Score: %d", var.scores)
}

# Output: ["Score: 95", "Score: 85", "Score: 75"]
####################################################################################

# 3. Formatting a List of Floats

variable "percentages" {
  default = [0.875, 0.923, 0.658]
}

output "formatted_percentages" {
  value = formatlist("Percentage: %.1f%%", var.percentages)
}

# Output: ["Percentage: 87.5%", "Percentage: 92.3%", "Percentage: 65.8%"]
####################################################################################

# 4. Using Automatic Formatting with %v in Lists

variable "mixed_values" {
  default = [42, "banana", true]
}

output "formatted_list" {
  value = formatlist("Value: %v", var.mixed_values)
}

# Output: ["Value: 42", "Value: banana", "Value: true"]