resource "aws_instance" "bastion" {
  ami                         = var.ami-id
  instance_type               = "t2.micro"
  key_name                    = aws_key_pair.terra.key_name
  security_groups             = [aws_security_group.bastion_sg.id]
  subnet_id                   = aws_subnet.public_subnet[count.index].id
  associate_public_ip_address = true
  count                       = 1
  tags = {
    Name = "Bastion"
  }
  ebs_block_device {
    device_name = "/dev/sda1"
    volume_size = 15
    volume_type = "gp3"
  }
}

resource "aws_instance" "jenkins" {
  ami             = var.ami-id
  instance_type   = "t2.micro"
  key_name        = aws_key_pair.terra.key_name
  subnet_id       = aws_subnet.private_subnet[count.index].id
  security_groups = [aws_security_group.private-sg.id]
  count           = 1
  tags = {
    Name = "Jenkins"
  }
    ebs_block_device {
    device_name = "/dev/sda1"
    volume_size = 15
    volume_type = "gp3"
  }
}

resource "aws_instance" "app" {
  ami             = var.ami-id
  instance_type   = "t2.micro"
  key_name        = aws_key_pair.terra.key_name
  subnet_id       = aws_subnet.private_subnet[count.index].id
  security_groups = [aws_security_group.private-sg.id]
  count           = 1
  tags = {
    Name = "app"
  }
    ebs_block_device {
    device_name = "/dev/sda1"
    volume_size = 15
    volume_type = "gp3"
  }
}