variable vpc_cidr_block {
    description = "The cidr_block of the VPC"
}
variable vpc_name {
    description = "The name of VPC"
}
variable public_subnet_cidr_block {
    type = list(string)
}
variable private_subnet_cidr_block {
    type = list(string)
}
variable public_subnet_name {
    type = list(string)
}
variable private_subnet_name {
    type = list(string)
}