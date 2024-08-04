# frozen_string_literal: true

require 'fileutils'

BINARY_NAME = 'ruku'

def ruku_path
  home = Dir.home
  ruku_root = File.join(home, '.ruku')
  bin_dir = File.join(ruku_root, 'bin')
  File.join(bin_dir, BINARY_NAME)
end
