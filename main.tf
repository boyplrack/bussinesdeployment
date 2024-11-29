provider "aws" {
  region = "us-east-1" # Puedes cambiar esto a la región que prefieras
}

resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"  # Define el rango de direcciones IP para la VPC

  tags = {
    Name = "testvpc"
  }
}

resource "aws_subnet" "my_subnet" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "10.0.1.0/24"  # Define el rango de direcciones IP para la subred

  tags = {
    Name = "MiSubred"
  }
}

resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "MiInternetGateway"
  }
}

resource "aws_route_table" "my_route_table" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_igw.id
  }

  tags = {
    Name = "MiRouteTable"
  }
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.my_subnet.id
  route_table_id = aws_route_table.my_route_table.id
}