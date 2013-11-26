# encoding: utf-8

require File.expand_path("../helper", __FILE__)

class TestDineroMailIpnNotificationParser < Test::Unit::TestCase
  def setup
    @xml_file = fixture_file("ipn-v2-notification.xml")
    @bad_xml_file = fixture_file("malformed-ipn-v2-notification.xml")
  end

  def test_invalid_initialization
    assert_raise ArgumentError do
      DineroMailIpn::NotificationParser.new
    end
  end

  def test_valid_initialization
    notification_parser = DineroMailIpn::NotificationParser.new(@xml_file)
    assert notification_parser.doc.kind_of? Nokogiri::XML::Document
    assert notification_parser.valid?
  end

  def test_retrieve_valid_operations
    notification_parser = DineroMailIpn::NotificationParser.new(@xml_file)
    notification = notification_parser.parse
    operations = notification.operations
    assert operations.is_a? Array
    assert_equal operations.size, 2
  end

  def test_invalid_xml_file
    notification_parser = DineroMailIpn::NotificationParser.new(@bad_xml_file)

    assert !notification_parser.valid?

    notification = notification_parser.parse
    assert notification.nil?

    error = notification_parser.validate.map(&:message).first
    assert error =~ /No matching global declaration available for the validation root/
  end
end
