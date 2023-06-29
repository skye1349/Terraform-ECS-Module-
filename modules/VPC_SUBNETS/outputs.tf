output "public_subnet" {
  description = "public subnets"
  value       =  aws_subnet.public_subnet 
}
output "private_subnet" {
  description = "private subnets"
  value       =  aws_subnet.private_subnet 
}
output "vpc" {
    description = "vpc"
    value = aws_vpc.main
}
output "public_subnet_ids" {
  description = "The IDs of the public subnets"
  value       = [for subnet in aws_subnet.public_subnet : subnet.id]
}

output "private_subnet_ids" {
  description = "The IDs of the private subnets"
  value       = [for subnet in aws_subnet.private_subnet : subnet.id]
}