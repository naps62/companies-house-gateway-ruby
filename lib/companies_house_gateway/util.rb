module CompaniesHouseGateway
  module Util
    extend self
    # String helper
    def camelize(str)
      str.to_s.split('_').map(&:capitalize).join
    end

    def underscore(str)
      str.to_s.gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
        gsub(/([a-z\d])([A-Z])/,'\1_\2').
        tr("-", "_").
        downcase
    end

    def demodulize(str)
      str.to_s.split('::').last
    end
  end
end