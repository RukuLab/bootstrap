# frozen_string_literal: true

# Ruku class
class Ruku
  def self.installed?
    system('which ruku > /dev/null 2>&1')
    $CHILD_STATUS.success?
  end

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

  def self.download_release_file(file_name, url)
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

  def self.find_executable
    extracted_files = Dir.glob('*').select { |f| File.executable?(f) && File.file?(f) }

    if extracted_files.empty?
      abort('No executable binary found in the extracted files.')
    elsif extracted_files.size > 1
      abort('Multiple executables found in the extracted files. Please check the archive.')
    else
      first = extracted_files.first
      if first.nil?
        abort('Unexpected error: first element is nil.')
      else
        first
      end
    end
  end

  def self.move_binary_to_bin(binary_name)
    destination_dir = File.expand_path('~/bin')
    destination_path = File.join(destination_dir, binary_name)

    FileUtils.mv(binary_name, destination_path)

    puts "Binary moved to #{destination_path} and made executable."
  end

  def self.install
    file_name = release_file_name
    release_url = "https://github.com/RukuLab/ruku/releases/latest/download/#{file_name}"

    download_release_file(file_name, release_url)

    puts "Unzipping #{file_name}..."
    system("tar -xzf #{file_name}")

    binary_name = find_executable
    move_binary_to_bin(binary_name)

    File.delete(file_name)
    puts 'Cleaned up downloaded files.'
  end
end
