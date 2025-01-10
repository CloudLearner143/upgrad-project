resource "aws_lb" "app_lb" {
  name               = "app-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.public-sg.id]
  count              = length(aws_subnet.public_subnet)
  subnets            = [aws_subnet.public_subnet[0].id, aws_subnet.public_subnet[1].id]
  # subnets = [aws_subnet.public_subnet[count.index].id]
  enable_deletion_protection       = false
  enable_cross_zone_load_balancing = true

  tags = {
    Name = "Application Load Balancer"
  }
}

resource "aws_lb_target_group" "jenkins" {
  name     = "jenkins-tg"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = aws_vpc.upgrad-vpc.id
  
  health_check {
    path = "/jenkins"
    port = 8080
    protocol = "HTTP"
  }
}

resource "aws_lb_target_group" "app" {
  name     = "app-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.upgrad-vpc.id
}

resource "aws_lb_listener" "app_lb_listener" {
  count             = length(aws_lb.app_lb)
  load_balancer_arn = aws_lb.app_lb[count.index].arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"
    fixed_response {
      status_code  = 200
      content_type = "text/plain"
      message_body = "Jenkins is Running"
    }
  }
}

resource "aws_lb_listener_rule" "redirect-to-jenkins" {
  count        = length(aws_lb_listener.app_lb_listener)
  listener_arn = aws_lb_listener.app_lb_listener[count.index].arn
  priority     = 1

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.jenkins.arn
  }

  condition {
    path_pattern {
      values = ["/jenkins*"]
    }
  }
}

resource "aws_lb_listener_rule" "redirect-to-app" {
  count        = length(aws_lb_listener.app_lb_listener)
  listener_arn = aws_lb_listener.app_lb_listener[count.index].arn
  priority     = 2

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }

  condition {
    path_pattern {
      values = ["/app", "/app*"]
    }
  }
}
