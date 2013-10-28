require "looker_pull"
require 'vcr'

LOOKER = {
  host: "looker.example.com",
  port: 9998,
  token: "nfjnfjjfnjfnrmSoQ5K2Q",
  secret: "djnjsdnjndjndjlaoru31ef9IvtgEHkBjiBfvZ"
}

VCR.configure do |c|
  c.allow_http_connections_when_no_cassette = true
  c.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  c.hook_into :webmock
end
