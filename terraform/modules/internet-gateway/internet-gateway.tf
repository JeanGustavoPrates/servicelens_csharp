resource "aws_internet_gateway" "igw" {
  vpc_id = var.aws_vpc.id
}

resource "aws_route_table" "rt" {
  vpc_id = var.aws_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "rta_subnet_1" {
  subnet_id      = var.csharp_subnet_1.id
  route_table_id = aws_route_table.rt.id
}

resource "aws_route_table_association" "rta_subnet_2" {
  subnet_id      = var.csharp_subnet_2.id
  route_table_id = aws_route_table.rt.id
}

resource "aws_route" "pub-vpc-module" {
  count = length(var.public_route_destinations)
  
  route_table_id         = aws_route_table.rt.id
  destination_cidr_block = element(var.public_route_destinations, count.index)
  network_interface_id   = ""

  timeouts {
    create = "5m"
  }
}