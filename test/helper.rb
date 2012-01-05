require 'test/unit'
require 'shoulda'
require 'fakeweb'

FakeWeb.allow_net_connect = false

def fixture_file(filename)
  return '' if filename == ''
  file_path = File.expand_path(File.dirname(__FILE__) + '/fixtures/' + filename)
  File.read(file_path)
end

def dinero_mail_url(path, options = {})
  options[:https] = true if options[:https].nil?
  options[:country] ||= 'argentina'
  protocol = (options[:https] == true) ? 'https' : 'http'
  "#{protocol}://#{options[:country]}.dineromail.com#{path}"
end

def stub_get(path, filename, options={})
  opts = {:body => fixture_file(filename)}.merge(options)

  FakeWeb.register_uri(:get, dinero_mail_url(path), opts)
end

def stub_post(path, filename, options={})
  opts = {:body => fixture_file(filename)}.merge(options)

  FakeWeb.register_uri(:post, dinero_mail_url(path, options[:url]), opts)
end
