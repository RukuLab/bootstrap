#!/usr/bin/env ruby

def install_docker_dependencies
  case RUBY_PLATFORM
  when /ubuntu|debian/
    system("sudo apt-get update")
    system("sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common")
  when /centos|fedora|rhel/
    system("sudo yum install -y yum-utils device-mapper-persistent-data lvm2")
  when /arch/
    # Arch Linux doesn't require additional dependencies for Docker
  else
    puts "Unsupported distribution"
    exit 1
  end
end

def install_docker
  case RUBY_PLATFORM
  when /ubuntu|debian/
    system("curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -")
    system("sudo add-apt-repository \"deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable\"")
    system("sudo apt-get update")
    system("sudo apt-get install -y docker-ce docker-ce-cli containerd.io")
  when /centos|fedora|rhel/
    system("sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo")
    system("sudo yum install -y docker-ce docker-ce-cli containerd.io")
  when /arch/
    system("sudo pacman -Sy docker --noconfirm")
  else
    puts "Unsupported distribution"
    exit 1
  end
end

def start_docker
  system("sudo systemctl start docker")
  system("sudo systemctl enable docker")
end

puts "Installing Docker dependencies..."
install_docker_dependencies

puts "Installing Docker..."
install_docker

puts "Starting Docker service..."
start_docker

puts "Docker installation complete!"
