# frozen_string_literal: true

require_relative 'constants'

# Ruku class
class Ruku
  def self.release_file_name
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

  def self.move_binary_to_bin(binary_name)
    home = Dir.home
    binary_path = File.join(Dir.pwd, binary_name)
    ruku_root = File.join(home, '.ruku')
    bin_dir = File.join(ruku_root, 'bin')
    bin_path = File.join(bin_dir, binary_name)

    if File.exist?(bin_path)
      puts 'Replacing existing ruku binary...'
      FileUtils.rm(bin_path)
    end

    puts "Moving ruku binary to #{bin_dir}..."
    FileUtils.mv(binary_path, bin_dir)

    puts 'ruku binary installed successfully!'
  end

  def self.install
    file_name = release_file_name
    release_url = "https://github.com/RukuLab/ruku/releases/latest/download/#{file_name}"

    puts "Downloading #{file_name}..."
    system("wget -q --show-progress #{release_url}")

    puts "Unzipping #{file_name}..."
    system("tar -xzf #{file_name}")

    move_binary_to_bin(BINARY_NAME)

    File.delete(file_name)
    puts 'Cleaned up downloaded files.'
  end
end
