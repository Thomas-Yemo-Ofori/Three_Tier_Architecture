#!/bin/bash

sudo apt update -y && sudo apt upgrade -y
sudo apt install apache2 -y
sudo systemctl enable apache2
sudo systemctl start apache2
sudo echo "<h1>Welcome to DevOps Engineering!</h1>" > /var/www/html/index.html