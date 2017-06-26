require "spec_helper"
require "json"

context "after provision finishes" do
  [:server1, :server2, :server3 ].each do |s|
    describe server(s) do
      it "is a member of the cluster" do
        r = current_server.ssh_exec("curl -s -XGET -u guest:guest http://localhost:15672/api/cluster-name")
        json = JSON.parse(r)
        expect(json["name"]).to eq "foo"
      end
    end
  end
end
