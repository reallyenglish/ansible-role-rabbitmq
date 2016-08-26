require 'spec_helper'
require 'serverspec'

package = 'rabbitmq'
service = 'rabbitmq'
config  = '/etc/rabbitmq/rabbitmq.conf'
user    = 'rabbitmq'
group   = 'rabbitmq'
ports   = [ 5673, 4369, 25672 ] # AMQP transport, Erlang Port Mapper (epmd), rabbitmq node port
log_dir = '/var/log/rabbitmq'
db_dir  = '/var/lib/rabbitmq'

case os[:family]
when 'freebsd'
  config = '/usr/local/etc/rabbitmq/rabbitmq.config'
  db_dir = '/var/db/rabbitmq'
end

describe package(package) do
  it { should be_installed }
end 

describe file(config) do
  it { should be_file }
  its(:content) { should match Regexp.escape('{rabbit') }
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
when 'freebsd'
  describe file('/etc/rc.conf.d/rabbitmq') do
    it { should be_file }
  end
end

describe service(service) do
  it { should be_running }
  it { should be_enabled }
end

ports.each do |p|
  describe port(p) do
    it { should be_listening }
  end
end
