####################################################################
########################### Create a VPC  ##############################
####################################################################

resource "aws_vpc" "three_tier" {
  cidr_block           = var.vpc_cidr
  instance_tenancy     = var.vpc_tenancy
  enable_dns_hostnames = var.enable_dns_hostname
  enable_dns_support   = var.enable_dns_support

  tags = {
    Name = "${var.project_name}_vpc"
  }
}

######################################################################
######################### Create Internet Gateway ##########################
######################################################################

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.three_tier.id

  tags = {
    Name = "${var.project_name}_vpc_gw"
  }
}

######################################################################
########################## Create Public Subnets ###########################
######################################################################

resource "aws_subnet" "pub_sub_1a" {
  vpc_id                  = aws_ssm_parameter.vpc_id.value
  cidr_block              = var.pub_sub_1a_cidr
  availability_zone       = var.availability_zones[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project_name}_pub_sub_1a"
  }
}

resource "aws_subnet" "pub_sub_1b" {
  vpc_id                  = aws_ssm_parameter.vpc_id.value
  cidr_block              = var.pub_sub_1b_cidr
  availability_zone       = var.availability_zones[1]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project_name}_pub_sub_1b"
  }
}

######################################################################
########################## Create Private Subnets ##########################
######################################################################

resource "aws_subnet" "prvt_sub_1a" {
  vpc_id                  = aws_ssm_parameter.vpc_id.value
  cidr_block              = var.prvt_sub_1a_cidr
  availability_zone       = var.availability_zones[0]
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.project_name}_prvt_sub_1a"
  }
}

resource "aws_subnet" "prvt_sub_1b" {
  vpc_id                  = aws_ssm_parameter.vpc_id.value
  cidr_block              = var.prvt_sub_1b_cidr
  availability_zone       = var.availability_zones[1]
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.project_name}_prvt_sub_1b"
  }
}

resource "aws_subnet" "db_prvt_sub_1a" {
  vpc_id                  = aws_ssm_parameter.vpc_id.value
  cidr_block              = var.db_prvt_sub_1a_cidr
  availability_zone       = var.availability_zones[0]
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.project_name}_db_prvt_sub_1a"
  }
}

resource "aws_subnet" "db_prvt_sub_1b" {
  vpc_id                  = aws_ssm_parameter.vpc_id.value
  cidr_block              = var.db_prvt_sub_1b_cidr
  availability_zone       = var.availability_zones[1]
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.project_name}_db_prvt_sub_1b"
  }
}

######################################################################
################### Create Route Table for Public Subnets ######################
######################################################################

resource "aws_route_table" "pub_rtb" {
  vpc_id     = aws_ssm_parameter.vpc_id.value
  depends_on = [aws_internet_gateway.igw]

  route {
    cidr_block = var.pub_rtb_cidr
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.project_name}_pub_rtb"
  }
}

resource "aws_route_table_association" "pub_rtb_ass_1a" {
  route_table_id = aws_route_table.pub_rtb.id
  subnet_id      = aws_ssm_parameter.pub_sub_1a_id.value
  depends_on     = [aws_route_table.pub_rtb]
}

resource "aws_route_table_association" "pub_rtb_ass_1b" {
  route_table_id = aws_route_table.pub_rtb.id
  subnet_id      = aws_ssm_parameter.pub_sub_1b_id.value
  depends_on     = [aws_route_table.pub_rtb]
}

######################################################################
############################ Create Elastic IP #############################
######################################################################

resource "aws_eip" "eip_nat_gw_1a" {
  domain     = "vpc"
  depends_on = [aws_internet_gateway.igw]

  tags = {
    Name = "${var.project_name}_eip_nat_gw_1a"
  }
}


resource "aws_eip" "eip_nat_gw_1b" {
  domain     = "vpc"
  depends_on = [aws_internet_gateway.igw]

  tags = {
    Name = "${var.project_name}_eip_nat_gw_1b"
  }
}

######################################################################
########################## Create NAT Gateways ###########################
######################################################################

resource "aws_nat_gateway" "nat_gw_1a" {
  subnet_id     = aws_ssm_parameter.prvt_sub_1a_id.value
  depends_on    = [aws_internet_gateway.igw]
  allocation_id = aws_eip.eip_nat_gw_1a.id

  tags = {
    Name = "${var.project_name}_nat_gw_1a"
  }
}

resource "aws_nat_gateway" "nat_gw_1b" {
  subnet_id     = aws_ssm_parameter.prvt_sub_1b_id.value
  depends_on    = [aws_internet_gateway.igw]
  allocation_id = aws_eip.eip_nat_gw_1b.id

  tags = {
    Name = "${var.project_name}_nat_gw_1b"
  }
}


######################################################################
################### Create Route Table for Private Subnets ######################
######################################################################

resource "aws_route_table" "prvt_rtb_1a" {
  vpc_id     = aws_ssm_parameter.vpc_id.value
  depends_on = [aws_nat_gateway.nat_gw_1a]

  route {
    cidr_block = var.prvt_rtb_cidr
    gateway_id = aws_nat_gateway.nat_gw_1a.id
  }

  tags = {
    Name = "${var.project_name}_prvt_rtb_1a"
  }
}

resource "aws_route_table" "prvt_rtb_1b" {
  vpc_id     = aws_ssm_parameter.vpc_id.value
  depends_on = [aws_nat_gateway.nat_gw_1b]

  route {
    cidr_block = var.prvt_rtb_cidr
    gateway_id = aws_nat_gateway.nat_gw_1b.id
  }

  tags = {
    Name = "${var.project_name}_prvt_rtb_1b"
  }
}

resource "aws_route_table_association" "prvt_rtb_ass_1a" {
  route_table_id = aws_route_table.prvt_rtb_1a.id
  subnet_id      = aws_ssm_parameter.prvt_sub_1a_id.value
  depends_on     = [aws_route_table.prvt_rtb_1a]
}

resource "aws_route_table_association" "prvt_rtb_ass_1b" {
  route_table_id = aws_route_table.prvt_rtb_1b.id
  subnet_id      = aws_ssm_parameter.prvt_sub_1b_id.value
  depends_on     = [aws_route_table.prvt_rtb_1b]
}


######################################################################
##################### Create Route Table for DB Subnets ######################
######################################################################

resource "aws_route_table" "db_prvt_rtb_1a" {
  vpc_id     = aws_ssm_parameter.vpc_id.value
  depends_on = [aws_nat_gateway.nat_gw_1a]

  route {
    cidr_block = var.db_prvt_rtb_cidr
    gateway_id = aws_nat_gateway.nat_gw_1a.id
  }

  tags = {
    Name = "${var.project_name}_db_prvt_rtb_1a"
  }
}

resource "aws_route_table" "db_prvt_rtb_1b" {
  vpc_id     = aws_ssm_parameter.vpc_id.value
  depends_on = [aws_nat_gateway.nat_gw_1b]

  route {
    cidr_block = var.db_prvt_rtb_cidr
    gateway_id = aws_nat_gateway.nat_gw_1b.id
  }

  tags = {
    Name = "${var.project_name}_db_prvt_rtb_1b"
  }
}

resource "aws_route_table_association" "db_prvt_rtb_ass_1a" {
  route_table_id = aws_route_table.db_prvt_rtb_1a.id
  subnet_id      = aws_ssm_parameter.db_prvt_sub_1a_id.value
  depends_on     = [aws_route_table.db_prvt_rtb_1a]
}

resource "aws_route_table_association" "db_prvt_rtb_ass_1b" {
  route_table_id = aws_route_table.db_prvt_rtb_1b.id
  subnet_id      = aws_ssm_parameter.db_prvt_sub_1b_id.value
  depends_on     = [aws_route_table.db_prvt_rtb_1b]
}