# encoding: utf-8

require 'helper'
require 'dinero_mail_ipn'

class TestDineromailIpnReport < Test::Unit::TestCase

  def test_invalid_report
    xml_response = <<-XML
<?xml version="1.0" encoding="ISO-8859-1"?>
<REPORTE>
  <ESTADOREPORTE>2</ESTADOREPORTE>
</REPORTE>
XML
    report = DineroMailIpn::Report.new(xml_response)
    assert !report.valid?
  end

  def test_valid_report
    xml_response = <<-XML
<?xml version="1.0" encoding="ISO-8859-1"?>
<REPORTE>
<ESTADOREPORTE>1</ESTADOREPORTE>
</REPORTE>
XML
    report = DineroMailIpn::Report.new(xml_response)
    assert report.valid?
  end

  def test_report_id
    xml_response = fixture_file("ConsultaTransacciones1Success.xml")
    report = DineroMailIpn::Report.new(xml_response)
    assert_equal 1, report.id
  end

  def test_report_amount
    xml_response = fixture_file("ConsultaTransacciones1Success.xml")
    report = DineroMailIpn::Report.new(xml_response)
    assert_equal 1010, report.amount
  end

  def test_report_completed
    xml_response = fixture_file("ConsultaTransacciones1Success.xml")
    report = DineroMailIpn::Report.new(xml_response)
    assert report.transaction_completed?
  end

end
