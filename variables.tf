variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "Three-Tier-Architecture"
}

variable "region" {
  description = "Region where the resources will be created"
  type        = string
  default     = "us-west-2"
}

variable "envs" {
  description = "Environments to create solutions"
  type        = list(string)
  default     = ["dev", "test", "prod"]
}

variable "availability_zones" {
  description = "Availability zones for the VPC"
  type        = list(string)
  default     = ["us-west-2a", "us-west-2b"]
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "vpc_tenancy" {
  description = "Tenancy for the VPC"
  type        = string
  default     = "default"
}

variable "enable_dns_hostname" {
  description = "Enable DNS hostname for the VPC"
  type        = bool
  default     = true
}

variable "enable_dns_support" {
  description = "Enable DNS support for the VPC"
  type        = bool
  default     = true
}

variable "pub_sub_1a_cidr" {
  description = "Public subnet in AZ1"
  type        = string
  default     = "10.0.1.0/24"
}

variable "pub_sub_1b_cidr" {
  description = "Public subnet in AZ2"
  type        = string
  default     = "10.0.2.0/24"
}

variable "prvt_sub_1a_cidr" {
  description = "Private subnet in AZ1"
  type        = string
  default     = "10.0.3.0/24"
}

variable "prvt_sub_1b_cidr" {
  description = "Private subnet in AZ2"
  type        = string
  default     = "10.0.4.0/24"
}

variable "db_prvt_sub_1a_cidr" {
  description = "Private subnet in AZ1"
  type        = string
  default     = "10.0.5.0/24"
}

variable "db_prvt_sub_1b_cidr" {
  description = "Private subnet in AZ2"
  type        = string
  default     = "10.0.6.0/24"
}

variable "pub_rtb_cidr" {
  description = "Route table for the public subnet in both AZs"
  type        = string
  default     = "0.0.0.0/0"
}

variable "prvt_rtb_cidr" {
  description = "Route table for the private subnet in both AZs"
  type        = string
  default     = "0.0.0.0/0"
}

variable "db_prvt_rtb_cidr" {
  description = "Route table for the database private subnet in both AZs"
  type        = string
  default     = "0.0.0.0/0"
}

variable "ssh_port" {
  description = "SSH port for instances"
  type        = number
  default     = 22
}

variable "http_port" {
  description = "HTTP port for instances"
  type        = number
  default     = 80
}

variable "https_port" {
  description = "HTTPS port for instances"
  type        = number
  default     = 443
}

variable "alb_listener" {
  description = "ALB listener for instances"
  type        = list(string)
  default     = ["80", "HTTP"]
}

variable "instance_type" {
  description = "HTTPS port for instances"
  type        = list(string)
  default = ["t2.micro","t2.medium", "t2.large"]
}

variable "sonar_port" {
  description = "Sonarqube port"
  type        = number
  default     = 9000
}

variable "bastion_host_instance_type" {
  description = "Instance type for the jump server to connect to the application server"
  type        = string
  default     = "t2.micro"
}

variable "db_port" {
  description = "This is the db port"
  type = number
  default = 3306
}

variable "db_storage_size" {
  description = "This is the db storage size"
  type = number
  default = 20
}

variable "db_engine" {
  description = "This is the db engine"
  type =string
  default ="mysql"
}

variable "db_engine_version" {
  description = "This is the db engine version"
  type =string
  default ="8.0"
}

variable "db_instance_class" {
  description = "This is the db instance class"
  type =string
  default ="db.t3.micro"
}

variable "db_username" {
  description = "This is the db username"
  type =string
  default ="three_tier"
}

variable "db_parameter_name" {
  description = "This is the db parameter name"
  type =string
  default ="default.mysql8.0"
}