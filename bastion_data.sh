#!/bin/bash

# Update packages on the server
sudo apt update -y
sudo apt upgrade -y

# Securely copy the app_server_key pair to the bastion host
cat "${tls_private_key.app_server.private_key_pem}" > /home/ubuntu/app_server_key_pair.pem
sudo chmod 400 /home/ubuntu/app_server_key_pair.pem