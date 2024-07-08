#!/usr/bin/env ruby
# frozen_string_literal: true

require 'English'
require 'open3'
require 'tempfile'
require 'fileutils'

require_relative 'ruku'
require_relative 'docker'
require_relative 'ssh'

def main
  if Docker.installed?
    puts 'Docker is already installed.'
    if Docker.running?
      puts 'Docker is running.'
    else
      puts 'Starting Docker...'
      system('sudo systemctl start docker')
    end
  else
    puts 'Installing Docker...'
    Docker.install
    puts 'Docker installation complete!'
  end

  puts 'Ruku is already installed.' if Ruku.installed?
  puts 'Installing the latest Ruku...'
  Ruku.install
  puts 'Ruku installation complete!'

  puts 'Setup SSH...'
  SSH.install

end

main
