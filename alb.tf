######################################################################
############################# Create Web ALB ############################
######################################################################

resource "aws_lb" "web_alb" {
  name               = "${var.project_name}-web-alb"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.web_alb_sg.id]
  subnets            = [aws_ssm_parameter.pub_sub_1a_id.value, aws_ssm_parameter.pub_sub_1b_id.value]

  tags = {
    Name = "${var.project_name}_web_alb"
  }
}

resource "aws_lb_target_group" "web_alb_tg" {
  name                 = "${var.project_name}-web-tg"
  vpc_id               = aws_ssm_parameter.vpc_id.value
  target_type          = "instance"
  port                 = var.http_port
  protocol             = "HTTP"
  deregistration_delay = 300
  health_check {
    path                = "/health"
    port                = var.http_port
    protocol            = "HTTP"
    interval            = 15
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
  tags = {
    Name = "${var.project_name}_web_alb_tg"
  }
}

resource "aws_lb_listener" "web_listener" {
  load_balancer_arn = aws_lb.web_alb.arn
  port              = var.alb_listener[0]
  protocol          = var.alb_listener[1]
  depends_on        = [aws_lb_target_group.web_alb_tg]

  default_action {
    type = "forward"

    target_group_arn = aws_lb_target_group.web_alb_tg.arn
  }
  tags = {
    Name = "${var.project_name}_web_listener"
  }
}


######################################################################
############################# Create App ALB ############################
######################################################################

resource "aws_lb" "app_alb" {
  name               = "${var.project_name}-app-alb"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.app_alb_sg.id]
  subnets            = [aws_ssm_parameter.prvt_sub_1a_id.value, aws_ssm_parameter.prvt_sub_1b_id.value]

  tags = {
    Name = "${var.project_name}_app_alb"
  }
}

resource "aws_lb_target_group" "app_alb_tg" {
  name                 = "${var.project_name}-app-tg"
  vpc_id               = aws_ssm_parameter.vpc_id.value
  target_type          = "instance"
  port                 = var.http_port
  protocol             = "HTTP"
  deregistration_delay = 300
  health_check {
    path                = "/health"
    port                = var.http_port
    protocol            = "HTTP"
    interval            = 15
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
  tags = {
    Name = "${var.project_name}_app_alb_tg"
  }
}

resource "aws_lb_listener" "app_listener" {
  load_balancer_arn = aws_lb.app_alb.arn
  port              = var.alb_listener[0]
  protocol          = var.alb_listener[1]
  depends_on        = [aws_lb_target_group.app_alb_tg]

  default_action {
    type = "forward"

    target_group_arn = aws_lb_target_group.app_alb_tg.arn
  }
  tags = {
    Name = "${var.project_name}_app_listener"
  }
}