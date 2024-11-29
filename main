provider "aws" {
  region = "us-east-1"
}

# VPC
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "main-vpc"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main-internet-gateway"
  }
}

# Tabla de rutas públicas
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "public-route-table"
  }
}

# Subnet en la zona us-east-1a
resource "aws_subnet" "public_a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"
  tags = {
    Name = "public-subnet-a"
  }
}

# Subnet en la zona us-east-1b
resource "aws_subnet" "public_b" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1b"
  tags = {
    Name = "public-subnet-b"
  }
}

# Asociaciones de la tabla de rutas públicas con las subnets
resource "aws_route_table_association" "public_a" {
  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_b" {
  subnet_id      = aws_subnet.public_b.id
  route_table_id = aws_route_table.public.id
}

# Grupo de seguridad
resource "aws_security_group" "web_sg" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
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
    Name = "web-sg"
  }
}

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

# Application Load Balancer
resource "aws_lb" "web_lb" {
  name               = "web-load-balancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.web_sg.id]
  subnets            = [aws_subnet.public_a.id, aws_subnet.public_b.id]
  tags = {
    Name = "WebALB"
  }
}

# Target group para el ALB
resource "aws_lb_target_group" "web_tg" {
  name        = "web-target-group"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main.id
  target_type = "instance"

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

# Listener del ALB
resource "aws_lb_listener" "web_listener" {
  load_balancer_arn = aws_lb.web_lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_tg.arn
  }
}

# Adjuntar instancias al Target Group
resource "aws_lb_target_group_attachment" "web_server_1" {
  target_group_arn = aws_lb_target_group.web_tg.arn
  target_id        = aws_instance.web_server_1.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "web_server_2" {
  target_group_arn = aws_lb_target_group.web_tg.arn
  target_id        = aws_instance.web_server_2.id
  port             = 80
}
