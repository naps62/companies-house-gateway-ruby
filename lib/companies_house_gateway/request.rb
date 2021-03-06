module CompaniesHouseGateway
  class Request
    def initialize(connection, config)
      @connection = connection
      @config = config
    end

    # Perform a check
    def perform(request_type, request_data = {})
      request_type = Util.camelize(request_type)
      unless Constants::SUPPORTED_REQUESTS.include?(request_type)
        msg = "Unsupported request type #{request_type}"
        raise CompaniesHouseGatewayError.new(msg)
      end

      response = @connection.post { |request|
        request.path = @config[:api_endpoint]
        request.body = build_request_xml(request_type, request_data).to_s
        request.options.open_timeout = @config[:open_timeout]
        request.options.timeout = @config[:timeout]
      }
      @config[:raw] ? response : response.body
    rescue Faraday::ServerError, Faraday::ClientError => e
      if e.response.nil?
        raise CompaniesHouseGatewayError.new
      else
        raise CompaniesHouseGatewayError.new(e.response[:body],
          e.response[:status],
          e.response)
      end
    end

    # Compile the complete XML request to send to Companies House
    def build_request_xml(request_type, request_data = {})
      transaction_id = (Time.now.to_f * 100).to_i

      builder = Nokogiri::XML::Builder.new { |xml|
        xml.GovTalkMessage(header_namespace) do
          xml.EnvelopeVersion "2.0"
          xml.Header do
            message_details(xml, request_type, transaction_id)
            authentication(xml, transaction_id)
          end
          xml.GovTalkDetails
          xml.Body do
            request_body(xml, request_type, request_data)
          end
        end
      }
      builder.doc
    end

    private

    def header_namespace
      {
        "xmlns" => "http://www.govtalk.gov.uk/CM/envelope",
        "xmlns:dsig" => "http://www.w3.org/2000/09/xmldsig#",
        "xmlns:gt" => "http://www.govtalk.gov.uk/CM/core",
        "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance",
        "xsi:schemaLocation" => "http://www.govtalk.gov.uk/CM/envelope " +
          "http://xmlgw.companieshouse.gov.uk/v1-1/schema/Egov_ch-v2-0.xsd"
      }
    end

    def message_details(xml, request_type, transaction_id)
      xml.MessageDetails do
        xml.Class request_type
        xml.Qualifier "request"
        xml.TransactionID transaction_id
      end
    end

    def authentication(xml, transaction_id)
      xml.SenderDetails do
        xml.IDAuthentication do
          xml.SenderID @config[:sender_id]
          xml.Authentication do
            xml.Method "CHMD5"
            xml.Value create_digest(transaction_id)
          end
        end
        xml.EmailAddress @config[:email] if @config[:email]
      end
    end

    def request_body(xml, request_type, search_data)
      request_type = "CompanyAppt" if request_type == "CompanyAppointments"
      xml.send("#{request_type}Request", request_namespace(request_type)) do
        search_data.each do |key, value|
          if value
            element_name = Util.camelize(key).sub(/Id\z/, "ID")
            cleaned_value = Validations.clean_param(key, value)
            xml.send(element_name, cleaned_value)
          end
        end
      end
    end

    def request_namespace(request_type)
      {
        "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance",
        "xsi:schemaLocation" => "http://xmlgw.companieshouse.gov.uk/v1-0/schema " +
          "http://xmlgw.companieshouse.gov.uk/v1-0/schema/#{request_type}.xsd"
      }
    end

    def create_digest(transaction_id)
      creds = "#{@config[:sender_id]}#{@config[:password]}#{transaction_id}"
      Digest::MD5.hexdigest(creds)
    end
  end
end
