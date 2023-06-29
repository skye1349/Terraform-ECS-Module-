//create IGW
resource "aws_internet_gateway" "igw" {
  vpc_id = var.vpc_id
  tags = {
    name = var.igw_name
  }
}
//create eip for NAT
resource "aws_eip" "nat_gateway" {
  count  = length(var.public_subnet_ids)
  tags   = {
    Name = "eip_natgateway${count.index + 1}"
  }
}
//create 2 NAT
resource "aws_nat_gateway" "nat_gateway" {
  count          = length(var.public_subnet_ids)
  allocation_id  = aws_eip.nat_gateway[count.index].id
  subnet_id      = var.public_subnet_ids[count.index]
  tags = {
    Name = "natgateway${count.index + 1}"
  }
}
//create public route table and associate.
resource "aws_route_table" "public" {
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.gateway_id
  }

}
resource "aws_route_table_association" "public" {
  count          = 1
  subnet_id      = var.public_subnet_ids[0]
  route_table_id = aws_route_table.public.id
}

//create private route table and associate
resource "aws_route_table" "private" {
  count  = length(var.private_subnet_ids)
  vpc_id = var.vpc_id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway[count.index].id
  }
  
}
resource "aws_route_table_association" "private" {
  count          = length(var.private_subnet_ids)
  subnet_id      = var.private_subnet_ids[count.index]
  route_table_id = aws_route_table.private[count.index].id
}

