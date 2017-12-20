require "spec_helper"

context "after provision finishes" do
  [server(:server1), server(:server2), server(:server3)].each do |s|
    describe s do
      %w[
        rabbitmq_management
        rabbitmq_delayed_message_exchange
      ].each do |p|
        it "has #{p} plug-ins installed" do
          r = current_server.ssh_exec("sudo rabbitmq-plugins list -E -m")
          expect(r).to match(/^#{p}$/)
        end
      end
    end
  end
end
