#!/bin/bash

# Update the system
sudo apt-get update -y

# Install Docker
sudo apt install docker.io -y

# Start docker service
sudo service docker start

# To ensure docker service starts after each reboot
sudo systemctl enable docker

# Switch user mode to ec2-user
sudo usermod -aG docker ubuntu

# Installing Jenkins

sudo apt-get upgrade -y

sudo apt-get install openjdk-11-jdk -y

curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo tee \
  /usr/share/keyrings/jenkins-keyring.asc > /dev/null

echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null

sudo apt-get update -y

sudo apt-get install jenkins -y

sudo systemctl start jenkins.service

sudo systemctl status jenkins

sudo usermod -aG docker jenkins


