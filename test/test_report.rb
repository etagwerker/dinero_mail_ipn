# encoding: utf-8

require File.expand_path('../helper', __FILE__)

class TestDineromailIpnReport < Test::Unit::TestCase

  def test_report_id
    report = DineroMailIpn::Report.new(:id => 33)
    assert_equal 33, report.id
  end

  def test_report_amount
    report = DineroMailIpn::Report.new(:amount => 3003)
    assert_equal 3003, report.amount
  end

  def test_transaction_completed?
    report = DineroMailIpn::Report.new(:state => 2)
    assert report.transaction_completed?
  end

  def test_transaction_pending?
    report = DineroMailIpn::Report.new(:state => 1)
    assert report.transaction_pending?
  end

  def test_transaction_cancelled?
    report = DineroMailIpn::Report.new(:state => 3)
    assert report.transaction_cancelled?
  end

end
