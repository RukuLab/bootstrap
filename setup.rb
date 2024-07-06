#!/usr/bin/env ruby

require 'open-uri'
require 'fileutils'

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

def check_ruku_installed?
  system('which ruku > /dev/null 2>&1')
end

def get_release_file_name
  arch = `uname -m`.strip

  case arch
  when 'x86_64'
    'ruku-linux-amd64.tar.gz'
  when 'aarch64'
    'ruku-linux-arm64.tar.gz'
  else
    abort("Unsupported architecture: #{arch}")
  end
end

def download_release_file(file_name, url)
  puts "Downloading #{file_name}..."
  open(url) do |download|
    File.open(file_name, 'wb') do |file|
      file.write(download.read)
    end
  end
  puts "Downloaded #{file_name}"
end

def find_ruku_executable
  extracted_files = Dir.glob('*').select { |f| File.executable?(f) && File.file?(f) }

  if extracted_files.empty?
    abort("No executable binary found in the extracted files.")
  elsif extracted_files.size > 1
    abort("Multiple executables found in the extracted files. Please check the archive.")
  end

  extracted_files.first
end

def move_binary_to_bin(binary_name)
  destination_dir = File.expand_path('~/bin')
  destination_path = File.join(destination_dir, binary_name)

  FileUtils.mv(binary_name, destination_path)
  FileUtils.chmod('+x', destination_path)

  puts "Binary moved to #{destination_path} and made executable."
end

def install_ruku
  file_name = get_release_file_name
  release_url = "https://github.com/RukuLab/ruku/releases/latest/download/#{file_name}"

  download_file(file_name, release_url)

  puts "Unzipping #{file_name}..."
  system("tar -xzf #{file_name}")

  binary_name = find_ruku_executable
  move_binary_to_bin(binary_name)

  File.delete(file_name)
  puts "Cleaned up downloaded files."
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

if check_ruku_installed?
  puts "Ruku is already installed."
else
  puts "Installing Ruku..."
  install_ruku
  puts "Ruku installation complete!"
end
