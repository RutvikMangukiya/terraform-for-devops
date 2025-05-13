variable "subnets" {
    description = "List of subnets to create"
    type = list(object({
      name = string
      cidr_block= string
      availability_zone = string 
    }))
}