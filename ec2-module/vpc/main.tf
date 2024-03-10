# Create VPC
resource "aws_vpc" "my_vpc" {
  cidr_block = var.cidr_block
}

# Associate route table with subnets in each availability zone
resource "aws_subnet" "my_subnet" {
  count             = length(var.availability_zones)
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.0.${count.index}.0/24"
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name = "my_subnet_${count.index + 1}"
  }
}

resource "aws_route_table_association" "my_subnet_association" {
  count          = length(var.availability_zones)
  subnet_id      = aws_subnet.my_subnet[count.index].id
  route_table_id = aws_route_table.my_route_table.id
}

# Create internet gateway
resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id
}

# Create route table
resource "aws_route_table" "my_route_table" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_igw.id
  }
}

output "vpc_id" {
  value = aws_vpc.my_vpc.id
}
