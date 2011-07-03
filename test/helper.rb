require 'test/unit'
require 'shoulda'
require 'fakeweb'

FakeWeb.allow_net_connect = false

def fixture_file(filename)
  return '' if filename == ''
  file_path = File.expand_path(File.dirname(__FILE__) + '/fixtures/' + filename)
  File.read(file_path)
end

def dinero_mail_url(url)
  url =~ /^https/ ? url : "https://argentina.dineromail.com#{url}"
end

def stub_get(url, filename, options={})
  opts = {:body => fixture_file(filename)}.merge(options)
  
  headers = {
  }
  
  FakeWeb.register_uri(:get, dinero_mail_url(url), headers.merge(opts))
end
