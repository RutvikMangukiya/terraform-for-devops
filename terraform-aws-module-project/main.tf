# Dev Infrastructure
module "dev-infra" {
    source = "./infra-app"
    env = "dev"
    bucket_name = "terraform-infra-bucket-rutvik"
    instance_count = 1
    instance_type = "t2.small"
    ec2_ami_id = "ami-0d866da98d63e2b42" # Ubuntu
    hash_key = "studentID"
}

# Prod Infrastructure
module "prod-infra" {
    source = "./infra-app"
    env = "prod"
    bucket_name = "terraform-infra-bucket-rutvik"
    instance_count = 2
    instance_type = "t2.micro"
    ec2_ami_id = "ami-0d866da98d63e2b42" # Ubuntu
    hash_key = "studentID"
}

# Stage Infrastructure
module "stg-infra" {
    source = "./infra-app"
    env = "stg"
    bucket_name = "terraform-infra-bucket-rutvik"
    instance_count = 1
    instance_type = "t2.small"
    ec2_ami_id = "ami-0d866da98d63e2b42" # Ubuntu
    hash_key = "studentID"
}