#!/usr/bin/env ruby
# frozen_string_literal: true

require 'English'
require 'fileutils'

require_relative 'ruku'
require_relative 'docker'

def main
  if Docker.installed?
    puts 'Docker is already installed.'
    system('docker version')
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

  if Ruku.installed?
    ruku_version = `ruku --version`.chomp.sub(/^ruku /, '')
    puts "Ruku version: #{ruku_version} (Ruku is already installed.)"
  end

  puts 'Installing the latest Ruku...'
  Ruku.install
  puts 'Ruku installation complete!'
end

main
