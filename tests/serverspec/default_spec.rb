require "spec_helper"
require "serverspec"

package = "rabbitmq"
service = "rabbitmq"
config  = "/etc/rabbitmq/rabbitmq.config"
env_config = "/etc/rabbitmq/rabbitmq-env.conf"
user    = "rabbitmq"
group   = "rabbitmq"
ports   = [5672, 4369, 25_672] # AMQP transport, Erlang Port Mapper (epmd), rabbitmq node port
log_dir = "/var/log/rabbitmq"
db_dir  = "/var/lib/rabbitmq"

case os[:family]
when "debian", "ubuntu"
  package = "rabbitmq-server"
  service = "rabbitmq-server"
when "freebsd"
  config = "/usr/local/etc/rabbitmq/rabbitmq.config"
  db_dir = "/var/db/rabbitmq"
  env_config = "/usr/local/etc/rabbitmq/rabbitmq-env.conf"
end

describe package(package) do
  it { should be_installed }
end

describe file(config) do
  it { should be_file }
  its(:content) { should match Regexp.escape("{rabbit") }
  its(:content) { should match Regexp.escape("{log_levels, [{connection, info}]},") }
  its(:content) { should match Regexp.escape("{vm_memory_high_watermark, 0.4},") }
  its(:content) { should match Regexp.escape("{vm_memory_high_watermark_paging_ratio, 0.5},") }
  its(:content) { should match Regexp.escape('{disk_free_limit, "50MB"}') }
end

describe file(env_config) do
  it { should be_file }
  its(:content) { should match(/^FOO="1"/) }
  its(:content) { should match(/^BAR="2"$/) }
  its(:content) { should match(/^USE_LONGNAME="1"$/) }
end

describe file(log_dir) do
  it { should exist }
  it { should be_mode 755 }
  it { should be_owned_by user }
  it { should be_grouped_into group }
end

describe file(db_dir) do
  it { should exist }
  it { should be_mode 755 }
  it { should be_owned_by user }
  it { should be_grouped_into group }
end

case os[:family]
when "freebsd"
  describe file("/etc/rc.conf.d/rabbitmq") do
    it { should be_file }
  end
end

describe service(service) do
  it { should be_running }
  it { should be_enabled }
end

ports.each do |p|
  describe port(p) do
    if (p == 25_672) && os[:family] =~ /^(debian|ubuntu)$/
      it do
        pending("the official deb package from debian is too old and behaves differently")
        should be_listening
      end
    else
      it { should be_listening }
    end
  end
end
