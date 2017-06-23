require "spec_helper"

class ServiceNotReady < StandardError
end

sleep 10 if ENV["JENKINS_HOME"]

context "after provisioning finished" do
  describe server(:client1) do
    it "ping server IP address" do
      result = current_server.ssh_exec("ping -c 1 #{server(:server1).server.address} && echo OK")
      expect(result).to match(/OK/)
    end
  end

  describe server(:server1) do
    it "ping client IP address" do
      result = current_server.ssh_exec("ping -c 1 #{server(:client1).server.address} && echo OK")
      expect(result).to match(/OK/)
    end
  end

  # being able to resolve host name is a requirement to form a clustor
  describe server(:server1) do
    it "ping server2 hostname" do
      r = current_server.ssh_exec("ping -qc 1 server2.virtualbox.reallyenglish.com")
      expect(r).to match(/^1 packets transmitted, 1 packets received, 0.0% packet loss$/)
    end
  end

  describe server(:server2) do
    it "ping server1 hostname" do
      r = current_server.ssh_exec("ping -qc 1 server1.virtualbox.reallyenglish.com")
      expect(r).to match(/^1 packets transmitted, 1 packets received, 0.0% packet loss$/)
    end
  end

  # https://www.rabbitmq.com/networking.html
  ports = [
    4369, # epmd
    5672, # AMQP
    5671, # AMQP TLS
    25672 # Erlang
  ]
  servers =[
    :server1,
    :server2,
    :server3
  ]
  servers.each do |s|
    describe server(s) do
      others = servers.reject{|i| i == s }
      others.each do |dest|
        describe firewall(server(dest)) do

          # IP address is used in this test
          it { is_expected.to be_reachable }
          ports.each do |p|
            it do
              pending "be_reachable does not work on FreeBSD https://github.com/otahi/infrataster-plugin-firewall/pull/4"
              is_expected.to be_reachable.tcp.dest_port(p)
            end
          end
        end
      end
    end
  end
end
