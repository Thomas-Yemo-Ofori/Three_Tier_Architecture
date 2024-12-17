#!/bin/bash

sudo yum update -y
sudo yum install -y httpd
sudo systemctl start httpd
sudo systemctl enable httpd
sudo echo "<h1>Welcome to DevOps Engineering!</h1>" > /var/www/html/index.html
