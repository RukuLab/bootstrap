#!/usr/bin/env ruby
# frozen_string_literal: true

require 'English'
require 'fileutils'

require_relative 'docker'

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
end

main
