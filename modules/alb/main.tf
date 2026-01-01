resource "aws_lb" "abra" {
  name               = "${var.app_name}-alb"
  internal           = true
  load_balancer_type = "application"
  subnets            = var.private_subnets
  security_groups    = [aws_security_group.alb.id]
}

resource "aws_security_group" "alb" {
  vpc_id = var.vpc_id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [var.vpc_link_sg_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.abra.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.abra.arn
  }
}