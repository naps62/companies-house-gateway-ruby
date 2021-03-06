require 'spec_helper'

describe CompaniesHouseGateway::Checks::NameSearch do
  describe "#perform" do
    let(:check_data) { { company_name: "GoCardless", data_set: "LIVE" } }

    it_behaves_like "it generates valid xml"
    it_behaves_like "it returns only the body of the response"
    it_behaves_like "it validates presence", :company_name
  end
end
