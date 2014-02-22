require 'spec_helper'

describe CompaniesHouseGateway::Client do
  let(:client) { CompaniesHouseGateway::Client.new(config) }
  let(:config) { CompaniesHouseGateway::Config.new }
  let(:check_data) { {} }

  describe "#new" do
    context "without a config" do
      before { configure_companies_house_gateway }
      subject(:new_client) { CompaniesHouseGateway::Client.new }

      its(:config) { should_not == CompaniesHouseGateway.config }
      it "has the attributes of the global config" do
        new_client.config[:sender_id] ==
          CompaniesHouseGateway.config[:sender_id]
      end
    end

    context "with a config" do
      before { config[:first_name] = "test" }
      subject(:new_client) { CompaniesHouseGateway::Client.new(config) }

      its(:config) { should_not == config }
      it "has the attributes of the passed in config" do
        new_client.config[:sender_id] == config[:sender_id]
      end
    end
  end

  describe "#perform_check" do
    subject(:perform_check) { client.perform_check(check_data) }

    it "delegates to an instance of Request" do
      expect_any_instance_of(CompaniesHouseGateway::Request).
        to receive(:perform).once
      client.perform_check(check_data)
    end
  end
end