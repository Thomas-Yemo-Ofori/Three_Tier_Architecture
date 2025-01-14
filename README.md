Three Tier Architecture with Terraform

This projects looks at deploying a three tier application - web tier, app tier and db tier - on AWS Cloud.
Before we begin, there are a few prerequisite that needs to facilitate a successful implementation.

Prerequisites:
1. Installation of AWSCLI
2. Installation of Terraform

# Network Infrastructure

1. Create VPC only
   - vpc cidr: 10.0.0.0/16

2. Create Two Public Subnets by allow assigning of public IP address
   - pub_sub_1a: 10.0.1.0/24
   - pub_sub_1b: 10.0.2.0/24

3. Create Two Private Subnets for app servers
   - app_pvt_sub_1a: 10.0.3.0/24
   - app_pvt_sub_1b: 10.0.4.0/24

4. Create Two Private Subnets for db servers
   - app_pvt_sub_1a: 10.0.5.0/24
   - app_pvt_sub_1b: 10.0.6.0/24

5. Create an internet gateway and attach to the VPC

6. Create route tables for public subnets and associate the two subnets and edit the routes to transmit traffic from the internet gateway

7. Create two nat gateways with elastic IP for the high availability in two azs

8. Create separate route tables for the app subnets and associate the subnets and edit the routes to receive traffic through the nat gateway

9. Create separate route tables for the db subnets and associate the subnets and edit the routes to receive traffic through the nat gateway


# Server Provisioning

1. Create a launch template for the web servers and paste the following shell script (bootstraping) in the user data 
- user_data: {
#!/bin/bash

sudo yum update -y
sudo yum install -y httpd
sudo systemctl start httpd
sudo systemctl enable httpd
sudo echo "<h1>Welcome to DevOps Engineering!</h1>" > /var/www/html/index.html
}

2. Create a security group for the web servers and allow
   - HTTP (0.0.0.0/0)
   - HTTPS (0.0.0.0/0)
   - SSH (0.0.0.0/0)

3. Create an auto scaling group for the web servers

4. Create a launch template for the app servers

5. Create a security group for the app servers and allow
   - ICMP (web_sg)
   - SSH (bastion_host_sg)
   - HTTP (web_sg)

6. Create an auto scaling group for the app servers

7. Create target groups for web and app servers

8. Create security groups for both albs and allow
   - HTTP (0.0.0.0/0)
   - HTTPS (0.0.0.0/0)

9. Create an application load balancer for web and app servers

10. Create a bastion host security group and allow
   - SSH (MY_IP)

11. Create a bastion host

12. Create a security for database 
    - MYSQL: 3306

13. Create a RDS MySQL database instance (free-tier)


# Happy Learning!