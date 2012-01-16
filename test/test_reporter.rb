# encoding: utf-8

require File.expand_path('../helper', __FILE__)

class TestDineromailIpnReporter < Test::Unit::TestCase

  def test_invalid_report_should_return_invalid
    xml_response = <<-XML
<?xml version="1.0" encoding="ISO-8859-1"?>
<REPORTE>
  <ESTADOREPORTE>2</ESTADOREPORTE>
</REPORTE>
XML
    reporter = DineroMailIpn::Reporter.new(xml_response)
    assert !reporter.valid?
  end

  def test_invalid_report_should_has_no_reports
    xml_response = <<-XML
<?xml version="1.0" encoding="ISO-8859-1"?>
<REPORTE>
  <ESTADOREPORTE>2</ESTADOREPORTE>
</REPORTE>
XML
    reporter = DineroMailIpn::Reporter.new(xml_response)
    assert reporter.reports.empty?
  end

  def test_valid_report_should_be_valid
    xml_response = <<-XML
<?xml version="1.0" encoding="ISO-8859-1"?>
<REPORTE>
<ESTADOREPORTE>1</ESTADOREPORTE>
</REPORTE>
XML
    reporter = DineroMailIpn::Reporter.new(xml_response)
    assert reporter.valid?
  end

  def test_reports_should_be_created_from_multiple_reports_response
    xml_response = fixture_file("ConsultaTransacciones1-2Success.xml")
    reporter = DineroMailIpn::Reporter.new(xml_response)
    assert_equal 2, reporter.reports.size
    assert reporter.reports.kind_of?(Array)
    assert reporter.reports.first.kind_of?(DineroMailIpn::Report)
  end

  def test_reports_should_be_created_from_single_report_response
    xml_response = fixture_file("ConsultaTransacciones1Success.xml")
    reporter = DineroMailIpn::Reporter.new(xml_response)
    assert_equal 1, reporter.reports.size
    assert reporter.reports.kind_of?(Array)
    assert reporter.reports.first.kind_of?(DineroMailIpn::Report)
  end

end
