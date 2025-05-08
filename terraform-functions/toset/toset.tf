variable "my_list" {
  default = ["apple", "banana", "apple", "orange"]
}

output "unique_fruits" {
  value = toset(var.my_list)
}

# In this example, the toset function converts the list ["apple", "banana", "apple", "orange"] into a set, resulting in {"apple", "banana", "orange"} by removing the duplicate "apple."
# This is particularly useful when you want to ensure unique values in your configurations.