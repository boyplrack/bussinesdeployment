
# Instancia EC2 en la zona us-east-1a
resource "aws_instance" "web_server_1" {
  ami           = "ami-0453ec754f44f9a4a" # Amazon Linux 2
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public_a.id
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  user_data = <<-EOF
                #!/bin/bash
                # Actualizar paquetes
                sudo yum update -y
                # Instalar Apache HTTPD
                sudo yum install -y httpd
                # Iniciar y habilitar el servicio Apache
                sudo systemctl start httpd
                sudo systemctl enable httpd
                # Crear una página de prueba
                echo "Hello from Web Server 1" > /var/www/html/index.html
              EOF
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
  user_data = <<-EOF
                #!/bin/bash
                # Actualizar paquetes
                sudo yum update -y
                # Instalar Apache HTTPD
                sudo yum install -y httpd
                # Iniciar y habilitar el servicio Apache
                sudo systemctl start httpd
                sudo systemctl enable httpd
                # Crear una página de prueba
                echo "Hello from Web Server 2" > /var/www/html/index.html
              EOF
  tags = {
    Name = "WebServer2"
  }
}
