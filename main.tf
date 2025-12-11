data "aws_vpc" "default" {
  default = true
}

# v2.x uses aws_subnet_ids (plural data source arrived later)
data "aws_subnets" "default" {
  vpc_id = data.aws_vpc.default.id
}

resource "aws_security_group" "alb" {
  name        = "alb-sg-demo"
  description = "ALB SG"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb" "demo" {
  name               = "alb-demo-${substr(replace(data.aws_vpc.default.id, "-", ""), 0, 8)}"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = data.aws_subnet_ids.default.ids
}

resource "aws_lb_target_group" "demo" {
  name     = "tg-demo"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.default.id
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.demo.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.demo.arn
  }
}

# ---- v2 syntax (works on v2, BREAKS on v3+) ----
resource "aws_lb_listener_rule" "host_rule" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 10

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.demo.arn
  }

  condition {
    field  = "host-header"
    values = ["app.example.com"]
  }
}
