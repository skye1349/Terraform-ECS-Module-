resource "aws_vpc" "main" {
  cidr_block       = var.vpc_cidr_block
  tags = {
    Name = var.vpc_name
  }
}
resource "aws_subnet" "public_subnet" {
  count = length(var.public_subnet_cidr_block)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.public_subnet_cidr_block[count.index]

  tags = {
    Name = var.public_subnet_name[count.index]
  }
}
resource "aws_subnet" "private_subnet" {
  count = length(var.private_subnet_cidr_block)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.private_subnet_cidr_block[count.index]

  tags = {
    Name = var.private_subnet_name[count.index]
  }
}