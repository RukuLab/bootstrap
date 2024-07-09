# frozen_string_literal: true

# This file is run inside the `ruku` userspace.

require 'fileutils'

def setup_directories
  home = Dir.home
  ruku_root = File.join(home, '.ruku')
  env_root = File.join(ruku_root, 'envs')
  git_root = File.join(ruku_root, 'repos')
  data_root = File.join(ruku_root, 'data')
  logs_root = File.join(ruku_root, 'logs')
  apps_root = File.join(home, 'apps')

  directories = [ruku_root, env_root, git_root, data_root, logs_root, apps_root]

  directories.each do |dir|
    unless File.directory?(dir)
      Dir.mkdir(dir)
      puts "Created directory: #{dir}"
    end
  end
end

setup_directories
