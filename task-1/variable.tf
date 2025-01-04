variable "aws_region" {
    default = "us-east-1"
}

variable "ami-id" {
    default = "ami-0e2c8caa4b6378d8c"
}

variable "vpc_cidr" {
    default = "10.10.0.0/16"
    description = "VPC CIDR block"
}

variable "public_subnet_cidr" {
    type = list
    default = ["10.10.1.0/24", "10.10.2.0/24"]
    description = "CIDR block for public subnet"
}

variable "private_subnet_cidr"{
    type = list(any)
    default = ["10.10.3.0/24", "10.10.4.0/24"]
    description = "CIDR block for private subnet"
}

variable "azs" {
    type = list
    default = ["us-east-1a", "us-east-1b"]
    description = "List of availability zones"
}

output "vpc_id" {
    value = aws_vpc.upgrad-vpc.id
}

output "public_subnet_id" {
    value = [aws_subnet.public_subnet[*].id]
}

output "private_subnet_id" {
    value = [aws_subnet.private_subnet[*].id]
}

output "nat_gatway_id" {
    value = aws_nat_gateway.upgrad-nat[*].id
}

output "internet_gatway_id" {
    value = aws_internet_gateway.upgrad-igw.id
}

output "bastion_public_ip" {
    value = aws_instance.bastion[*].public_ip
}

output "jenkins_public_ip" {
    value = aws_instance.jenkins[*].public_ip
}

output "app_public_ip" {
    value = aws_instance.app[*].public_ip
}

output "alb_dns_name" {
    value = aws_lb.app_lb[*].dns_name
}