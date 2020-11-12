require File.expand_path("../lib/companies_house_gateway/version", __FILE__)

Gem::Specification.new do |gem|
  gem.add_runtime_dependency "faraday_middleware", ">= 1.0.0", "< 1.1"
  gem.add_runtime_dependency "multi_xml", "~> 0.6.0"
  gem.add_runtime_dependency "nokogiri", "~> 1.10"

  gem.add_development_dependency "rspec", "~> 3.0"
  gem.add_development_dependency "webmock", "~> 1.21"

  gem.authors = ["Grey Baker", "Miguel Palhas"]
  gem.description = "Ruby wrapper for the Companies House XML Gateway"
  gem.email = ["grey@gocardless.com", "mpalhas@gmail.com"]
  gem.files = `git ls-files`.split("\n")
  gem.homepage = "https://github.com/naps62/companies-house-gateway-ruby"
  gem.name = "companies-house-gateway"
  gem.require_paths = ["lib"]
  gem.summary = "Ruby wrapper for the Companies House XML Gateway"
  gem.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.version = CompaniesHouseGateway::VERSION.dup
end
