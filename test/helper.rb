require 'test/unit'
require 'shoulda'
require 'fakeweb'
require File.expand_path('../../lib/dinero_mail_ipn', __FILE__)

FakeWeb.allow_net_connect = false

# Reads a fixture file from /test/fixtures/
# 
# @param [String] File name with extension
# @return [File]
def fixture_file(filename)
  return '' if filename == ''
  file_path = File.expand_path(File.dirname(__FILE__) + '/fixtures/' + filename)
  File.read(file_path)
end

# Translates a relative path into a 
# absolute URL.
# 
# @param [String] Relative path
# @param [Hash] Options: :https => true, :country => 'chile'
# @return [String] Absolute URL
def dinero_mail_url(path, options = {})
  options[:https] = true if options[:https].nil?
  options[:country] ||= 'argentina'
  protocol = (options[:https] == true) ? 'https' : 'http'
  "#{protocol}://#{options[:country]}.dineromail.com#{path}"
end

# Stubs a GET request for the relative path,
# using the fixture file.
# 
# @param [String] Relative path
# @param [String] Fixture file name
# @param [Hash] Options for FakeWeb.register_uri
def stub_get(path, filename, options={})
  opts = {:body => fixture_file(filename)}.merge(options)

  FakeWeb.register_uri(:get, dinero_mail_url(path), opts)
end

# Stubs a POST request for the relative path,
# using the fixture file.
# 
# @param [String] Relative path
# @param [String] Fixture file name
# @param [Hash] Options for FakeWeb.register_uri
def stub_post(path, filename, options={})
  opts = {:body => fixture_file(filename)}.merge(options)

  FakeWeb.register_uri(:post, dinero_mail_url(path, options[:url]), opts)
end
