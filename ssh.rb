# frozen_string_literal: true

# SSH class
class SSH
  def self.install
    user = 'ruku'
    system("PAAS_USERNAME=#{user}")
    system("sudo adduser --disabled-password --gecos 'PaaS access' --ingroup www-data $PAAS_USERNAME")
  end

  def setup_authorized_keys(ssh_fingerprint, script_path, pub_key)
    authorized_keys = File.join(ENV['HOME'], '.ssh', 'authorized_keys')
    FileUtils.mkdir_p(File.dirname(authorized_keys)) unless File.exist?(File.dirname(authorized_keys))

    # Restrict features and force all SSH commands to go through our script
    File.open(authorized_keys, 'a') do |f|
      f.write("command=\"FINGERPRINT=#{ssh_fingerprint} NAME=default #{script_path} $SSH_ORIGINAL_COMMAND\",no-agent-forwarding,no-user-rc,no-X11-forwarding,no-port-forwarding #{pub_key}\n")
    end

    FileUtils.chmod(0o700, File.dirname(authorized_keys))
    FileUtils.chmod(0o600, authorized_keys)
  end
end
