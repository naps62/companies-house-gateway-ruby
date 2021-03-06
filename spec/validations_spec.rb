require 'spec_helper'

describe CompaniesHouseGateway::Validations do
  describe '#clean_string' do
    subject { CompaniesHouseGateway::Validations.clean_string(string, :param) }

    context "without a string" do
      let(:string) { nil }
      it { is_expected.to eq(nil) }
    end

    context "with a short string" do
      let(:string) { "A" * 160 }
      it { is_expected.to eq(string) }
    end

    context "with a long string" do
      let(:string) { "A" * 161 }
      it "raises an error" do
        expect { subject }.
          to raise_error CompaniesHouseGateway::InvalidRequestError
      end
    end
  end

  describe '#clean_date' do
    subject { CompaniesHouseGateway::Validations.clean_date(date, :param) }

    context "without a date" do
      let(:date) { nil }
      it { is_expected.to eq(nil) }
    end

    context "with a date object" do
      let(:date) { Date.parse("01/01/2000") }
      it { is_expected.to eq(date.strftime("%d/%m/%Y")) }
    end

    context "with a parseable string" do
      let(:date) { "01-01-2000" }
      it { is_expected.to eq("01/01/2000") }
    end

    context "with a load of rubbish" do
      let(:date) { "A couple of weeks ago" }
      it "raises an error" do
        expect { subject }.
          to raise_error CompaniesHouseGateway::InvalidRequestError
      end
    end
  end

  describe '#clean_boolean' do
    subject { CompaniesHouseGateway::Validations.clean_boolean(bool, :param) }

    context "without a boolean" do
      let(:bool) { nil }
      it { is_expected.to eq(nil) }
    end

    context "with a boolean" do
      let(:bool) { true }
      it { is_expected.to eq(bool) }
    end

    context "with a load of rubbish" do
      let(:bool) { "Sometimes" }
      it "raises an error" do
        expect { subject }.
          to raise_error CompaniesHouseGateway::InvalidRequestError
      end
    end
  end

  describe '#clean_number' do
    subject { CompaniesHouseGateway::Validations.clean_number(number, :param) }

    context "without a number" do
      let(:number) { nil }
      it { is_expected.to eq(nil) }
    end

    context "with a number" do
      let(:number) { 9 }
      it { is_expected.to eq(number.to_s) }
    end

    context "with a string that looks like a number" do
      let(:number) { "91" }
      it { is_expected.to eq(number) }
    end

    context "with a load of rubbish" do
      let(:number) { "Ninety five" }
      it "raises an error" do
        expect { subject }.
          to raise_error CompaniesHouseGateway::InvalidRequestError
      end
    end
  end

  describe '#clean_data_set' do
    subject { CompaniesHouseGateway::Validations.clean_data_set(data_set) }

    context "without a data_set" do
      let(:data_set) { nil }
      it { is_expected.to eq(nil) }
    end

    context "with a valid symbol" do
      let(:data_set) { :live }
      it { is_expected.to eq("LIVE") }
    end

    context "with a valid string" do
      let(:data_set) { "LIVE" }
      it { is_expected.to eq("LIVE") }
    end

    context "with a load of rubbish" do
      let(:data_set) { "ALL THE DATAS!!" }
      it "raises an error" do
        expect { subject }.
          to raise_error CompaniesHouseGateway::InvalidRequestError
      end
    end
  end

  describe '#clean_officer_type' do
    subject do
      CompaniesHouseGateway::Validations.clean_officer_type(officer_type)
    end

    context "without an officer_type" do
      let(:officer_type) { nil }
      it { is_expected.to eq(nil) }
    end

    context "with a valid symbol" do
      let(:officer_type) { :dis }
      it { is_expected.to eq("DIS") }
    end

    context "with a valid string" do
      let(:officer_type) { "DIS" }
      it { is_expected.to eq("DIS") }
    end

    context "with a load of rubbish" do
      let(:officer_type) { "ALL THE DATAS!!" }
      it "raises an error" do
        expect { subject }.
          to raise_error CompaniesHouseGateway::InvalidRequestError
      end
    end
  end

  describe '#clean_company_number' do
    subject do
      CompaniesHouseGateway::Validations.clean_company_number(number)
    end

    context "with a number that's too short" do
      let(:number) { "123456" }
      it "throws an exception" do
        expect { subject }.
          to raise_error CompaniesHouseGateway::InvalidRequestError
      end
    end

    context "with a number that's too long" do
      let(:number) { "123456789" }
      it "throws an exception" do
        expect { subject }.
          to raise_error CompaniesHouseGateway::InvalidRequestError
      end
    end

    context "with a number that contains spaces" do
      let(:number) { "1234 ABC" }
      it "throws an exception" do
        expect { subject }.
          to raise_error CompaniesHouseGateway::InvalidRequestError
      end
    end

    context "with a number that contains non alphanumeric chars" do
      let(:number) { "1234?456" }
      it "throws an exception" do
        expect { subject }.
          to raise_error CompaniesHouseGateway::InvalidRequestError
      end
    end

    CompaniesHouseGateway::Constants::ALLOWED_PREFIXES.each do |prefix|
      context "allows a company number starting with #{prefix}" do
        prefix = (prefix == '\d\d') ? '07' : prefix
        let(:number) { "#{prefix}112233" }
        it { is_expected.to eq("#{prefix}112233") }
      end
    end

    context "does not 0-pads 8 digit registration numbers" do
      let(:number) { "17495895" }
      it { is_expected.to eq("17495895") }
    end

    context "0-pads 7 digit registration numbers" do
      let(:number) { "7495895" }
      it { is_expected.to eq("07495895") }
    end

    context "0-pads 5 digit NI registration numbers" do
      let(:number) { "NI27768" }
      it { is_expected.to eq("NI027768") }
    end

    context "does not 0-pad 6 digit NI registration numbers" do
      let(:number) { "NI127768" }
      it { is_expected.to eq("NI127768") }
    end

    context "upcases prefixes" do
      let(:number) { "sc127768" }
      it { is_expected.to eq("SC127768") }
    end
  end
end
