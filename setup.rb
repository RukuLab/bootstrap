#!/usr/bin/env ruby
# frozen_string_literal: true

require 'English'
require 'net/http'
require 'fileutils'

# Docker installation and checking functions
def install_docker
  system('curl -fsSL https://get.docker.com -o get-docker.sh')
  system('sudo sh ./get-docker.sh')

  puts 'Run a test container to verify Docker is working'
  system('docker run --rm hello-world')
end

def check_docker_installed
  system('docker --version > /dev/null 2>&1')
  $CHILD_STATUS.success?
end

def check_docker_running
  system('docker info > /dev/null 2>&1')
  $CHILD_STATUS.success?
end

# Ruku download and installation functions
def check_ruku_installed?
  system('which ruku > /dev/null 2>&1')
end

def release_file_name
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
  uri = URI(url)
  Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
    request = Net::HTTP::Get.new(uri)
    http.request(request) do |response|
      File.open(file_name, 'wb') do |file|
        response.read_body do |chunk|
          file.write(chunk)
        end
      end
    end
  end
  puts "Downloaded #{file_name}"
end

def find_ruku_executable
  extracted_files = Dir.glob('*').select { |f| File.executable?(f) && File.file?(f) }

  if extracted_files.empty?
    abort('No executable binary found in the extracted files.')
  elsif extracted_files.size > 1
    abort('Multiple executables found in the extracted files. Please check the archive.')
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
  file_name = release_file_name
  release_url = "https://github.com/RukuLab/ruku/releases/latest/download/#{file_name}"

  download_release_file(file_name, release_url)

  puts "Unzipping #{file_name}..."
  system("tar -xzf #{file_name}")

  binary_name = find_ruku_executable
  move_binary_to_bin(binary_name)

  File.delete(file_name)
  puts 'Cleaned up downloaded files.'
end

# Main execution
if check_docker_installed
  puts 'Docker is already installed.'
  if check_docker_running
    puts 'Docker is running.'
  else
    puts 'Starting Docker...'
    system('sudo systemctl start docker')
  end
else
  puts 'Installing Docker...'
  install_docker
  puts 'Docker installation complete!'
end

if check_ruku_installed?
  puts 'Ruku is already installed.'
  ruku_path = File.expand_path('~/bin/ruku')
  File.delete(ruku_path)
end
puts 'Installing the latest Ruku...'
install_ruku
puts 'Ruku installation complete!'
