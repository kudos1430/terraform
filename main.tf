provider "aws" {
    region = "us-east-2"
access_key = "AKIA3ACNW5PKAGINZWVS"
secret_key = "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"
}

resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC"
  }
}

data "aws_availability_zones" "available" {
  
}
resource "aws_default_subnet" "default" {
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "Default subnet for us-east-2a"
  }
}
resource "aws_security_group" "allow_web" {
  name        = "allow_web-traffic"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_default_vpc.default.id

  ingress {
    description      = "HTTPS"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["10.0.1.0/24"]
    ipv6_cidr_blocks = ["::/0"]
  }
  ingress {
    description      = "HTTP"
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_web"
  }
}

resource "aws_instance" "Jenkins" {
    ami = "ami-06c4532923d4ba1ec"
    instance_type = "t2.micro"
    subnet_id = aws_default_subnet.default.id
    availability_zone = "us-east-2a"
    vpc_security_group_ids = [aws_security_group.allow_web.id]
    key_name = "terra-key"
tags = {
     Name= "Jenkins-vm"
}  

}
resource "null_resource" "name" {
    #ssh into ec2 instance
    connection {
    type = "ssh"
    user = "ubuntu"
    private_key = file("C:\\Users\\hamza.nasirmahmood\\Downloads\\terra-key.pem")
    host = aws_instance.Jenkins.public_ip  
    }

provisioner "file" {
    source = "install_jenkins.sh"
    destination = "/tmp/install_jenkins.sh"

}

provisioner "remote-exec" {
    inline = [
        "sudo sh chmod +x /tmp/install_jenkins.sh",
        "sh /tmp/install_jenkins.sh"
    ]
}

depends_on = [
    aws_instance.Jenkins
]

}