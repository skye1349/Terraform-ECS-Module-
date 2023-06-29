variable vpc_id{

}
variable igw_name {
    
}

variable gateway_id {
    
}
variable "public_subnet_ids" {
  description = "The IDs of the public subnets"
  type        = list(string)
}

variable "private_subnet_ids" {
  description = "The IDs of the private subnets"
  type        = list(string)
}