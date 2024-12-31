######################################################################
#################### Create Security Group for Web ASG #######################
######################################################################

resource "aws_security_group" "web_asg_sg" {
  name        = "web_asg_sg"
  vpc_id      = aws_ssm_parameter.vpc_id.value
  description = "Security Group for ${var.project_name}"

  ingress {
    from_port   = var.ssh_port
    to_port     = var.ssh_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "SSH"
  }

  ingress {
    from_port       = var.http_port
    to_port         = var.http_port
    protocol        = "tcp"
    security_groups = [aws_security_group.web_alb_sg.id]
    description     = "HTTP"
  }

  ingress {
    from_port   = var.https_port
    to_port     = var.https_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTPS"
  }

  ingress {
    from_port   = var.sonar_port
    to_port     = var.sonar_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Sonarqube"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}_web_asg_sg"
  }
}


######################################################################
#################### Create Security Group for Web ASG #######################
######################################################################

resource "aws_security_group" "app_asg_sg" {
  name        = "app_asg_sg"
  vpc_id      = aws_ssm_parameter.vpc_id.value
  description = "Security Group for ${var.project_name}"
  depends_on  = [aws_security_group.web_asg_sg]

  ingress {
    from_port       = var.ssh_port
    to_port         = var.ssh_port
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion_host_sg.id]
    description     = "SSH"
  }

  ingress {
    from_port       = -1
    to_port         = -1
    protocol        = "icmp"
    security_groups = [aws_security_group.web_asg_sg.id]
    description     = "ICMP"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}_app_asg_sg"
  }
}


######################################################################
################### Create a Security Group for Bastion Host ####################
######################################################################

# Create a security group for the bastin host
resource "aws_security_group" "bastion_host_sg" {
  description = "Security group for bastion host"
  name        = "${var.project_name}_bastion_host_sg"
  vpc_id      = aws_ssm_parameter.vpc_id.value
  depends_on  = [aws_vpc.three_tier]

  ingress {
    from_port   = var.ssh_port
    to_port     = var.ssh_port
    protocol    = "tcp"
    cidr_blocks = ["${data.http.my_ip.response_body}/32"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}_bastion_host_sg"
  }
}

######################################################################
#################### Create a Security Group for Web ALB ######################
######################################################################

# Create a security group for the alb
resource "aws_security_group" "web_alb_sg" {
  description = "Security group for application load balancer"
  name        = "${var.project_name}_web_alb_sg"
  vpc_id      = aws_ssm_parameter.vpc_id.value
  depends_on  = [aws_vpc.three_tier]

  ingress {
    from_port   = var.http_port
    to_port     = var.http_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = var.https_port
    to_port     = var.https_port
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
    Name = "${var.project_name}_web_alb_sg"
  }
}


######################################################################
#################### Create a Security Group for App ALB ######################
######################################################################

# Create a security group for the alb
resource "aws_security_group" "app_alb_sg" {
  description = "Security group for application load balancer"
  name        = "${var.project_name}_app_alb_sg"
  vpc_id      = aws_ssm_parameter.vpc_id.value
  depends_on  = [aws_vpc.three_tier]

  ingress {
    from_port   = var.http_port
    to_port     = var.http_port
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
    Name = "${var.project_name}_app_alb_sg"
  }
}


######################################################################
################### Create a Security Group for DB Instance ####################
######################################################################

resource "aws_security_group" "db_tier_sg" {
  name        = "${var.project_name}_db_tier_sg"
  description = "Security group for database"
  vpc_id      = aws_ssm_parameter.vpc_id.value
  depends_on  = [aws_vpc.three_tier]

  ingress {
    from_port       = var.db_port
    to_port         = var.db_port
    protocol        = "tcp"
    security_groups = [aws_security_group.app_asg_sg.id]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.project_name}_db_tier_sg"
  }
}