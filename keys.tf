######################################################################
########################### Create TLS Private Key ##########################
######################################################################

# Generate Bastion Host Public Key
resource "tls_private_key" "bastion" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

# Generate Webserver Public Key
resource "tls_private_key" "web_server" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

# Generate Appserver Public Key
resource "tls_private_key" "app_server" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

# Create a bation host keypair
resource "aws_key_pair" "bastion_key" {
  key_name   = "${var.project_name}_bastionkp"
  public_key = tls_private_key.bastion.public_key_openssh
}

# Create a webserver keypair
resource "aws_key_pair" "web_server_key" {
  key_name   = "${var.project_name}_web_server_key"
  public_key = tls_private_key.web_server.public_key_openssh
}

# Create an appserver keypair
resource "aws_key_pair" "app_server_key" {
  key_name   = "${var.project_name}_app_server_key"
  public_key = tls_private_key.app_server.public_key_openssh
}


######################################################################
########################## Create Local Private Key #########################
######################################################################

# Save the bastion host keypair as a local file
resource "local_file" "bastion_key_pair" {
  content         = tls_private_key.bastion.private_key_pem
  filename        = "${path.module}/key_pair/bastion_key_pair.pem"
  file_permission = "0600"
}

# Save the webserver keypair as a local file
resource "local_file" "web_server_key_pair" {
  content         = tls_private_key.web_server.private_key_pem
  filename        = "${path.module}/Key_Pair/web_server_key_pair.pem"
  file_permission = "0600"
}

# Save the appserver keypair as a local file
resource "local_file" "app_server_key_pair" {
  content         = tls_private_key.app_server.private_key_pem
  filename        = "${path.module}/Key_Pair/app_server_key_pair.pem"
  file_permission = "0600"
}
