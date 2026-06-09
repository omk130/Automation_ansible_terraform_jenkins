provider "aws" {
  region = "eu-west-1"
}


resource "aws_instance" "server" {
    ami           = "ami-0de864d6a3bd20ea8"
    instance_type = "t3.micro"

    key_name = "ansible-lab"

    tags = {
        Name = "jenkins-server"
    }
}