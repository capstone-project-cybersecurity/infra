

data "template_file" "init" {
  template = file(var.install_setup)
}

resource "aws_key_pair" "terraform-ec2-jenkins" {
  key_name   = "terraform-ec2-jenkins"
  public_key = file(var.ssh_key)
}

resource "aws_instance" "terraform-ec2-jenkins" {
  ami                         = var.ami
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.terraform-ec2-jenkins.key_name
  vpc_security_group_ids      = [aws_security_group.sg_allow_terraform-ec2-jenkins.id]
  subnet_id                   = aws_subnet.public-subnet-1.id
  user_data                   = file(var.install_setup)
  associate_public_ip_address = true
  tags = {
    Name = "terraform-ec2-jenkins"
  }
}

resource "aws_security_group" "sg_allow_terraform-ec2-jenkins" {
  name        = "allow_terraform-ec2-jenkins"
  description = "Allow SSH and terraform-ec2-jenkins inbound traffic"
  vpc_id      = aws_vpc.development-vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "terraform-ec2-jenkins-sg"
  }
}
