# frozen_string_literal: true

# Docker class
class Docker
  def self.install
    system('curl -fsSL https://get.docker.com -o get-docker.sh')
    system('sudo sh ./get-docker.sh')

    puts 'Run a test container to verify Docker is working'
    system('docker run --rm hello-world')
    system('rm ./get-docker.sh')
  end

  def self.installed?
    system('docker --version > /dev/null 2>&1')
    $CHILD_STATUS.success?
  end

  def self.running?
    system('docker info > /dev/null 2>&1')
    $CHILD_STATUS.success?
  end
end
