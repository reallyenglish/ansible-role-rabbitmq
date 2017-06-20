require "spec_helper"

context "after provision finishes" do
  [server(:server1), server(:server2)].each do |s|
    describe s do
      %w(
        rabbitmq_management
        rabbitmq_delayed_message_exchange
      ).each do |p|
        it "has #{p} plug-ins installed" do
          r = current_server.ssh_exec("sudo rabbitmq-plugins list")
          expect(r).to match(/\s#{p}\s/)
        end
      end
    end
  end
end
