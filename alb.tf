
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
