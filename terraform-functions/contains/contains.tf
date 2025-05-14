# 1. Checking for Presence

variable "animals" {
  default = ["cat", "dog", "bird"]
}

output "contains_dog" {
  value = contains(var.animals, "dog")
}

# contains_dog = true

# "dog" is in the list, so contains returns true.
#################################################

# 2. Value Not Present
output "contains_fish" {
  value = contains(var.animals, "fish")
}


# contains_fish = false

# "fish" isn't in the list, resulting in false.