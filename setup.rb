#!/usr/bin/env ruby

def install_docker
  system("curl -fsSL https://get.docker.com -o get-docker.sh")
  system("sudo sh ./get-docker.sh")

  puts "Run a test container to verify Docker is working"
  system("docker run --rm hello-world")
end

def check_docker_installed
  system("docker --version > /dev/null 2>&1")
  $?.success?
end

def check_docker_running
  system("docker info > /dev/null 2>&1")
  $?.success?
end

if check_docker_installed
  puts "Docker is already installed."
  if check_docker_running
    puts "Docker is running."
  else
    puts "Starting Docker..."
    system("sudo systemctl start docker")
  end
else
  puts "Installing Docker..."
  install_docker
  puts "Docker installation complete!"
end
