#-----------------------
#----VPC==>Module


data "aws_availability_zones" "hal_hazirki_region" {}


resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = var.env
  }
}


resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "New_Default_Gateway"
  }
}




resource "aws_subnet" "public_subnets" {
  count                   = length(var.public_subnets_cidrs)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = element(var.public_subnets_cidrs, count.index)
  availability_zone       = data.aws_availability_zones.hal_hazirki_region.names[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.env}-public-${count.index + 1}"
  }
}

resource "aws_route_table" "public_subnets" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
  tags = {
    Name = "simple_Route_table"
  }
}

resource "aws_route_table_association" "public_routers" {
  count          = length(aws_subnet.public_subnets[*].id)
  route_table_id = aws_route_table.public_subnets.id
  subnet_id      = element(aws_subnet.public_subnets[*].id, count.index)
}
