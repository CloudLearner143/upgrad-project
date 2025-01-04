resource "aws_lb" "app_lb" {
    name = "app-lb"
    internal = false
    load_balancer_type = "application"
    security_groups = [aws_security_group.public-sg.id]
    count = 1
    subnets = [aws_subnet.public_subnet[0].id, aws_subnet.public_subnet[1].id]
    # subnets = [aws_subnet.public_subnet[count.index].id]
    enable_deletion_protection = false
    enable_cross_zone_load_balancing = true

    tags = {
        Name =  "Application Load Balancer"
    }
}

resource "aws_lb_listener" "app_lb_listener" {
    count = length(aws_lb.app_lb)
    load_balancer_arn = aws_lb.app_lb[count.index].arn
    port = 80
    protocol = "HTTP"

    default_action {
        type = "fixed-response"
        fixed_response {
            status_code = 200
            content_type = "text/plain"
            message_body = "Welcome to App"
        }
    }
}