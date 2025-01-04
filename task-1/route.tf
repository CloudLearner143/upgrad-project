resource "aws_route_table" "public-rt" {
    vpc_id = aws_vpc.upgrad-vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.upgrad-igw.id
    }
}

resource "aws_route_table" "private-rt" {
    vpc_id = aws_vpc.upgrad-vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.upgrad-nat.id
    }
}

resource "aws_route_table_association" "public_association" {
    count = length(aws_subnet.public_subnet)
    subnet_id = aws_subnet.public_subnet[count.index].id
    route_table_id = aws_route_table.public-rt.id
}

resource "aws_route_table_association" "private-association" {
    count = length(aws_subnet.private_subnet)
    subnet_id = aws_subnet.private_subnet[count.index].id
    route_table_id = aws_route_table.private-rt.id
}
