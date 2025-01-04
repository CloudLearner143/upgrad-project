resource "aws_internet_gateway" "upgrad-igw" {
    vpc_id = aws_vpc.upgrad-vpc.id
    tags = {
        Name = "upgrad-igw"
    }
}

resource "aws_eip" "upgrad-eip" {
    domain = "vpc"
}

resource "aws_nat_gateway" "upgrad-nat" {
    allocation_id = aws_eip.upgrad-eip.id
    subnet_id = element(aws_subnet.public_subnet.*.id, 0)
    # count = 1
    tags = {
        Name = "upgrad-nat"
    }
    depends_on = [aws_internet_gateway.upgrad-igw]
}
