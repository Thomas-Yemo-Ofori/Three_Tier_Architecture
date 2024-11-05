######################################################################
########################### Create a Bastion Host ##########################
######################################################################

# Create an instance for the bastion host
resource "aws_instance" "bastion_host" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.bastion_host_instance_type
  key_name                    = aws_key_pair.bastion_key.key_name
  subnet_id                   = aws_ssm_parameter.pub_sub_1a_id.value
  vpc_security_group_ids      = [aws_security_group.bastion_host_sg.id]
  associate_public_ip_address = true
  user_data              = filebase64("${path.module}/bastion_data.sh")

  tags = {
    Name = "${var.project_name}_bastion_host"
    Environments = "${var.envs[0]}"
  }
}