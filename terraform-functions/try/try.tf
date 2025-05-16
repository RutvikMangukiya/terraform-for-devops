# 1. Basic Try Usage

variable "valid_variable" {
  default = "I am valid"
}

variable "invalid_variable" {
  default = null
}

output "try_example" {
  value = try(var.valid_variable, var.invalid_variable, "Fallback Value")
}

# Output: try_example = "I am valid"

# In this case, try returns var.valid_variable since it successfully evaluates without error.
#------------------------------------------------------------------------------------------------------------------------------------------

# 2. Handling Errors Gracefully

output "handle_errors" {
  value = try(length(var.invalid_variable), "Length calculation failed")
}

# Output: handle_errors = "Length calculation failed"

# Here, the length function fails because var.invalid_variable is null, so try returns the fallback string instead of throwing an error.
#------------------------------------------------------------------------------------------------------------------------------------------

# 3. Multiple Expressions

variable "input_value" {
  default = null
}

output "multiple_expressions" {
  value = try(length(var.input_value), var.valid_variable, "Fallback Result")
}

# Output: multiple_expressions = "I am valid"

# try first attempts to get the length of var.input_value, which is null (and fails), then it evaluates var.valid_variable, which succeeds.
#------------------------------------------------------------------------------------------------------------------------------------------

# 4. All Expressions Fail

output "all_fail" {
  value = try(null, null, null, "All expressions failed")
}

# Output: "All expressions failed"

# Since all provided expressions fail, try returns the final fallback string.