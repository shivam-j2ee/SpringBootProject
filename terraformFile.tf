locals {
  ami_id = "ami-0557a15b87f6559cf"
  vpc_id = "vpc-048615daaf31bc82f"
  ssh_user = "ubuntu"
  key_name = "skumar"
  private_key_path = "/home/ubuntu/TerraformScript/skumar.pem"
}

provider "aws" {
  access_key = "AKIA3Q6RUOSIL73RQH74"
  secret_key = "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"
  region = "us-east-1"
}

resource "aws_security_group" "demoaccess" {
  name = "demoaccessforTerraform"
  vpc_id = local.vpc_id

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_instance" "web" {
  ami = local.ami_id
  instance_type = "t2.micro"
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.demoaccess.id]
  key_name = local.key_name
  count = 2
  tags = {
    Name = "Demo test-${count.index}"
  }

  connection {
    type = "ssh"
    host = self.public_ip
    user = local.ssh_user
    private_key = file(local.private_key_path)
    timeout = "4m"
  }

  provisioner "remote-exec" {
    inline = [
      "touch /home/ubuntu/demo-file-from-terraform.txt"
    ]
  }
}

