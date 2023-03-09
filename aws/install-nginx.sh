#!/bin/bash
echo "updating system"
sudo yum update && sudo yum upgrade -y

echo "installing nginx"
sudo amazon-linux-extras install -y nginx1

echo "starting nginx server"
sudo systemctl start nginx && sudo systemctl enable nginx