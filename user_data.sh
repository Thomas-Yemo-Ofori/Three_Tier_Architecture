#!/bin/bash

sudo apt update -y && sudo apt upgrade -y
sudo apt install apache2 -y
sudo systemctl enable apache2
sudo systemctl start apache2
sudo echo "<h1>Welcome to DevOps Engineering!</h1>" > /var/www/html/index.html
# =======
# sudo yum update -y
# sudo yum install -y httpd
# sudo systemctl start httpd
# sudo systemctl enable httpd
# sudo echo "<h1>Welcome to DevOps Engineering!</h1>" > /var/www/html/index.html
