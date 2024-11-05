resource "aws_ssm_parameter" "vpc_id" {
  name       = "/${var.project_name}/vpc_id"
  type       = "String"
  value      = aws_vpc.three_tier.id
  depends_on = [aws_vpc.three_tier]
}

resource "aws_ssm_parameter" "pub_sub_1a_id" {
  name       = "/${var.project_name}/pub_sub_1a_id"
  type       = "String"
  value      = aws_subnet.pub_sub_1a.id
  depends_on = [aws_subnet.pub_sub_1a]
}

resource "aws_ssm_parameter" "pub_sub_1b_id" {
  name       = "/${var.project_name}/pub_sub_1b_id"
  type       = "String"
  value      = aws_subnet.pub_sub_1b.id
  depends_on = [aws_subnet.pub_sub_1b]
}

resource "aws_ssm_parameter" "prvt_sub_1a_id" {
  name       = "/${var.project_name}/prvt_sub_1a_id"
  type       = "String"
  value      = aws_subnet.prvt_sub_1a.id
  depends_on = [aws_subnet.prvt_sub_1a]
}

resource "aws_ssm_parameter" "prvt_sub_1b_id" {
  name       = "/${var.project_name}/prvt_sub_1b_id"
  type       = "String"
  value      = aws_subnet.prvt_sub_1b.id
  depends_on = [aws_subnet.prvt_sub_1b]
}

resource "aws_ssm_parameter" "db_prvt_sub_1a_id" {
  name       = "/${var.project_name}/db_prvt_sub_1a_id"
  type       = "String"
  value      = aws_subnet.db_prvt_sub_1a.id
  depends_on = [aws_subnet.db_prvt_sub_1a]
}

resource "aws_ssm_parameter" "db_prvt_sub_1b_id" {
  name       = "/${var.project_name}/db_prvt_sub_1b_id"
  type       = "String"
  value      = aws_subnet.db_prvt_sub_1b.id
  depends_on = [aws_subnet.db_prvt_sub_1b]
}