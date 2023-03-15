#######################################################################################
# Create application load balancer
#######################################################################################

resource "aws_lb" "application_load_balancer" {
  name               = "alb-redjon-test"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_security_group.id]
  /* subnets            = ["subnet-0c0e02906cf61332c", "subnet-09f6ccee580256269"] */
  subnets = ["subnet-0e8251e240b76f3d3", "subnet-043b57b849dd51957"]

  enable_deletion_protection = false

  tags = {
    Name = "my-alb-redjon"
  }
}

#######################################################################################
# Create application load balancer target group
#######################################################################################

resource "aws_lb_target_group" "alb_target_group" {
  name        = "alb-group"
  target_type = "ip"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id

  depends_on = [
    aws_lb.application_load_balancer
  ]

  health_check {
    enabled             = true
    interval            = 300
    path                = "/"
    timeout             = 30
    matcher             = 200
    healthy_threshold   = 5
    unhealthy_threshold = 5
  }

  lifecycle {
    create_before_destroy = true
  }
}

#######################################################################################
# Create a listener on port 80 with redirect action
#######################################################################################

resource "aws_lb_listener" "alb_http_listener" {
  load_balancer_arn = aws_lb.application_load_balancer.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"
    redirect {
      port        = 443
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

#######################################################################################
# Create a listener on port 443 with forward action
#######################################################################################

resource "aws_lb_listener" "alb_https_listener" {
  load_balancer_arn = aws_lb.application_load_balancer.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate.acm_certificate.arn #"arn:aws:acm:eu-central-1:535479077865:certificate/eda84cb1-d30d-48d6-b95c-7e9b49e8893b"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_target_group.arn
  }
}