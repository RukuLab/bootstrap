#!/usr/bin/env ruby

def install_docker
  system("curl -fsSL https://get.docker.com -o get-docker.sh")
  system("sudo sh ./get-docker.sh")

  puts "Run a test container to verify Docker is working"
  system("docker run --rm hello-world")
end

puts "Installing Docker..."
install_docker

puts "Docker installation complete!"
