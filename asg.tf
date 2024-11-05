######################################################################
#################### Create a Launch Template and Web ASG ###################
######################################################################

resource "aws_launch_template" "web_asg_lt" {
  name                   = "web_asg_lt"
  image_id               = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type[1]
  key_name               = aws_key_pair.web_server_key.key_name
  user_data              = filebase64("${path.module}/user_data.sh")

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.web_asg_sg.id]
  }

  tags = {
    Name         = "${var.project_name}_web_asg_lt"
    Environments = "${var.envs[0]}"
  }
}

resource "aws_autoscaling_policy" "target_tracking_scaling_policy_web" {
  name                      = "target_tracking_scaling_policy"
  policy_type               = "TargetTrackingScaling"
  estimated_instance_warmup = 300
  depends_on                = [aws_launch_template.web_asg_lt]

  autoscaling_group_name = aws_autoscaling_group.web_tier_asg.name

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 80.0
  }
}

# Create an auto_scaling group for the web servers
resource "aws_autoscaling_group" "web_tier_asg" {
  name                      = "${var.project_name}_web_asg"
  max_size                  = 5
  min_size                  = 2
  health_check_grace_period = 300
  health_check_type         = "ELB"
  desired_capacity          = 2
  vpc_zone_identifier       = [aws_ssm_parameter.pub_sub_1a_id.value, aws_ssm_parameter.pub_sub_1b_id.value]
  target_group_arns         = [aws_lb_target_group.web_alb_tg.arn]
  depends_on                = [aws_lb_target_group.web_alb_tg]

  launch_template {
    id      = aws_launch_template.web_asg_lt.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "${var.project_name}_web_tier_server"
    propagate_at_launch = true
  }
}


######################################################################
################### Create a Launch Template and App ASG ####################
######################################################################

resource "aws_launch_template" "app_asg_lt" {
  name                   = "app_asg_lt"
  image_id               = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type[1]
  key_name               = aws_key_pair.app_server_key.key_name
  user_data              = filebase64("${path.module}/user_data.sh")

  network_interfaces {
    associate_public_ip_address = false 
    security_groups             = [aws_security_group.app_asg_sg.id]
  }

  tags = {
    Name = "${var.project_name}_app_asg_lt"
    Environments = "${var.envs[0]}"
  }
}

resource "aws_autoscaling_policy" "target_tracking_scaling_policy_app" {
  name                      = "target_tracking_scaling_policy"
  policy_type               = "TargetTrackingScaling"
  estimated_instance_warmup = 300
  depends_on                = [aws_launch_template.app_asg_lt]

  autoscaling_group_name = aws_autoscaling_group.app_tier_asg.name

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 80.0
  }
}

# Create an auto_scaling group for the web servers
resource "aws_autoscaling_group" "app_tier_asg" {
  name                      = "${var.project_name}_app_asg"
  max_size                  = 5
  min_size                  = 2
  health_check_grace_period = 300
  health_check_type         = "ELB"
  desired_capacity          = 2
  vpc_zone_identifier       = [aws_ssm_parameter.prvt_sub_1a_id.value, aws_ssm_parameter.prvt_sub_1b_id.value]
  target_group_arns         = [aws_lb_target_group.app_alb_tg.arn]
  depends_on                = [aws_lb_target_group.app_alb_tg]

  launch_template {
    id      = aws_launch_template.app_asg_lt.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "${var.project_name}_app_tier_server"
    propagate_at_launch = true
  }
}
