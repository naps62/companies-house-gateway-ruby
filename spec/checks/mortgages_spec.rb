require 'spec_helper'

describe CompaniesHouseGateway::Checks::Mortgages do
  describe "#perform" do
    let(:check_data) do
      { company_name: "GoCardless",
        company_number: "07495895",
        user_reference: "asd121a" }
    end

    it_behaves_like "it generates_valid_xml"
    it_behaves_like "it validates presence", :company_name
    it_behaves_like "it validates presence", :company_number
    it_behaves_like "it validates presence", :user_reference
  end
end