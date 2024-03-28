provider "aws" {
  region = "us-east-2"
}

resource "aws_instance" "example" {
  ami           = "ami-0c101f26f147fa7fd"
  instance_type = "t2.micro"
  tags = {
    Name = var.ec2_name
  }
}
