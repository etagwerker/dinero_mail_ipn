# encoding: utf-8

require File.expand_path("../helper", __FILE__)

class TestDineroMailIpnNotificationParser < Test::Unit::TestCase
  def setup
    @xml_file = fixture_file("ipn-v2-notification.xml")
    @bad_xml_file = fixture_file("malformed-ipn-v2-notification.xml")
  end

  context "initialization" do
    should "fail when no XML is provided" do
      assert_raise ArgumentError do
        DineroMailIpn::NotificationParser.new
      end
    end

    should "fail when an invalid XML is provided" do
      notification_parser = DineroMailIpn::NotificationParser.new(@bad_xml_file)

      assert !notification_parser.valid?
    end

    should "pass when a valid XML is provided" do
      notification_parser = DineroMailIpn::NotificationParser.new(@xml_file)

      assert notification_parser.doc.kind_of? Nokogiri::XML::Document
      assert notification_parser.valid?
    end
  end

  context "retrieving notified operations" do
    context "from a valid XML notification" do
      should "retrieve all valid notified operations" do
        notification_parser = DineroMailIpn::NotificationParser.new(@xml_file)

        notification = notification_parser.parse

        operations = notification.operations

        assert operations.is_a? Array
        assert_equal operations.size, 2
      end
    end

    context "from an invalid XML notification" do
      should "return nothing if XML is invalid" do
        notification_parser = DineroMailIpn::NotificationParser.new(@bad_xml_file)
        notification = notification_parser.parse

        assert_nil notification
      end

      should "return a list of errors for that invalid XML" do
        notification_parser = DineroMailIpn::NotificationParser.new(@bad_xml_file)

        errors = notification_parser.validate
        error_message = errors.map(&:message).first

        assert error_message =~ /No matching global declaration available for the validation root/
      end
    end
  end
end
