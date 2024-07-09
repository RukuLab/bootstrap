# frozen_string_literal: true

# This file is run inside the `ruku` userspace.

require 'open3'
require 'tempfile'
require 'fileutils'

require_relative 'constants'

def setup(key_file)
  if File.exist?(key_file)
    begin
      fingerprint, = Open3.capture2("ssh-keygen -lf #{key_file}")
      fingerprint = fingerprint.split(' ')[1]
      key = File.read(key_file).strip
      puts "Adding key '#{fingerprint}'."
      setup_authorized_keys(fingerprint, RUKU_PATH, key)
    rescue StandardError => e
      puts "Error: invalid public key file '#{key_file}': #{e.message}"
    end
  elsif key_file == '-'
    buffer = $stdin.read
    Tempfile.create('pub_key') do |f|
      f.write(buffer)
      f.flush
      setup(f.path)
    end
  else
    puts "Error: public key file '#{key_file}' not found."
  end
end

def setup_authorized_keys(ssh_fingerprint, script_path, pub_key)
  authorized_keys = File.join(Dir.home, '.ssh', 'authorized_keys')
  FileUtils.mkdir_p(File.dirname(authorized_keys)) unless File.exist?(File.dirname(authorized_keys))

  # Restrict features and force all SSH commands to go through our script
  File.open(authorized_keys, 'a') do |f|
    f.write("command=\"FINGERPRINT=#{ssh_fingerprint} NAME=default #{script_path} $SSH_ORIGINAL_COMMAND\",no-agent-forwarding,no-user-rc,no-X11-forwarding,no-port-forwarding #{pub_key}\n")
  end

  FileUtils.chmod(0o700, File.dirname(authorized_keys))
  FileUtils.chmod(0o600, authorized_keys)
end

puts 'Setup SSH...'
setup(ARGV[0])
puts 'SSH setup done.'
