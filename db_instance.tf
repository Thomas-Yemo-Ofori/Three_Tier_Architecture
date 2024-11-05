######################################################################
######################### Create a DB SUbnet Group  ########################
######################################################################

resource "aws_db_subnet_group" "db_tier_sg" {
  name       = "three-tier-db-sg"
  subnet_ids = [aws_ssm_parameter.db_prvt_sub_1a_id.value, aws_ssm_parameter.db_prvt_sub_1b_id.value]

  tags = {
    Name = "${var.project_name}_db_tier_sg"
  }
}



######################################################################
################### Create a Random Password for DB Instance  #################
######################################################################

# Create a random password for the db
resource "random_password" "db_password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}


######################################################################
########################### Create a MySQL RDS  ##########################
######################################################################

# Create an RDS instance for the database
resource "aws_db_instance" "db_tier_instance" {
  allocated_storage      = var.db_storage_size
  db_name                = "three_tier_db"
  engine                 = var.db_engine
  engine_version         = var.db_engine_version
  instance_class         = var.db_instance_class
  username               = var.db_username
  password               = random_password.db_password.result
  parameter_group_name   = var.db_parameter_name
  db_subnet_group_name   = aws_db_subnet_group.db_tier_sg.name
  vpc_security_group_ids = [aws_security_group.db_tier_sg.id]
  identifier = "three-tier-db"
  publicly_accessible    = false
  skip_final_snapshot    = true
  storage_encrypted      = true

  tags = {
    Name = "${var.project_name}_db_tier"
  }
}