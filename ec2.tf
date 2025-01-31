
# Instancia EC2 en la zona us-east-1a
resource "aws_instance" "web_server_1" {
  ami           = "ami-0453ec754f44f9a4a" # Amazon Linux 2
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public_a.id
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  tags = {
    Name = "WebServer1"
  }
}

# Instancia EC2 en la zona us-east-1b
resource "aws_instance" "web_server_2" {
  ami           = "ami-0453ec754f44f9a4a" # Amazon Linux 2
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public_b.id
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  tags = {
    Name = "WebServer2"
  }
}
