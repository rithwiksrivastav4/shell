#!/bin/bash
echo "this is for installing aws cli"

echo "installing aws cli"
sudo apt-get update -y
sudo apt-get install -y unzip curl

# download latest aws cli
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"

# unzip with overwrite
unzip -o awscliv2.zip

# install
sudo ./aws/install --update

echo "AWS CLI installed successfully"
aws --version
