resource "aws_security_group" "bastion_sg" {
    name = "bastion-sg"
    description = "Allow ssh from self ip"
    vpc_id = aws_vpc.upgrad-vpc.id

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["${data.http.self_ip.body}/32"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_security_group" "private-sg" {
    name = "private-sg"
    vpc_id = aws_vpc.upgrad-vpc.id
    description = "Allow traffic within vpc"

    ingress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = [var.vpc_cidr]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_security_group" "public-sg" {
    name = "public-sg"
    vpc_id = aws_vpc.upgrad-vpc.id
    description = "Allow HTTP traffic from self IP"

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["${data.http.self_ip.body}/32"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

data "http" "self_ip" {
    url = "https://api.ipify.org/"
}