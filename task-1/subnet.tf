resource "aws_subnet" "public_subnet" {
    vpc_id = aws_vpc.upgrad-vpc.id
    cidr_block = var.public_subnet_cidr[count.index]
    availability_zone = var.azs[count.index]
    map_public_ip_on_launch = true
    count = 2
    tags = {
        Name = "public-subnet"
    }
}

resource "aws_subnet" "private_subnet" {
    cidr_block = var.private_subnet_cidr[count.index]
    availability_zone = var.azs[count.index]
    vpc_id = aws_vpc.upgrad-vpc.id
    map_public_ip_on_launch = false
    count = 2
    tags = {
        Name = "private-subnet"
    }
}