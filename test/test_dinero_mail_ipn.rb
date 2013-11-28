# encoding: utf-8
require File.expand_path('../helper', __FILE__)

class TestDineroMailIpn < Test::Unit::TestCase

  context "when I query the Dinero Mail API via GET" do

    should "return OK for the query with valid Pin and Account parameters" do
      stub_get("/vender/ConsultaPago.asp?XML=1&Acount=17128254&Pin=AYCN7IXDTM&Email=ernesto%40ombushop.com&StartDate=20110702&EndDate=20110703",
               "ConsultaPagoOkWithoutCollections.xml")
      client = DineroMailIpn::Client.new(:email => 'ernesto@ombushop.com',
                                          :account => '17128254',
                                          :pin => 'AYCN7IXDTM')
      response = client.consulta_pago(Date.new(2011,7,2), Date.new(2011,7,3))
      assert_equal response.state, "1"
      assert response.ok?
      assert_equal response.state_description, "La consulta se realizó correctamente"
    end

    should "return OK with 1 payment" do
      stub_get("/vender/ConsultaPago.asp?XML=1&Acount=17128254&Pin=AYCN7IXDTM&Email=ernesto%40ombushop.com&StartDate=20110702&EndDate=20110703",
         "ConsultaPagoOkWith1Pay.xml")
      client = DineroMailIpn::Client.new(:email => 'ernesto@ombushop.com',
                                          :account => '17128254',
                                          :pin => 'AYCN7IXDTM')
      response = client.consulta_pago(Date.new(2011,7,2), Date.new(2011,7,3))
      assert_equal "1", response.state
      assert_equal 1, response.payments.size
      assert response.ok?
      assert_equal "La consulta se realizó correctamente", response.state_description
      assert !response.payments.empty?
      payment = response.payments.first
      assert_equal "juanperez@ombushop.com", payment["Trx_Email"]
      assert_equal "R163000000", payment["trx_id"]
      assert payment["Trx_Numbr"].nil?
      assert !payment.items.empty?
      item = payment.items.first
      assert_equal "SKU123", item["Item_Code"]
      assert_equal "68.00", item["Item_Payment"]
      assert item["item_quantity"].nil?
    end

    should "return OK with 2 payments" do
      stub_get("/vender/ConsultaPago.asp?XML=1&Acount=17128254&Pin=AYCN7IXDTM&Email=ernesto%40ombushop.com&StartDate=20110702&EndDate=20110703",
         "ConsultaPagoOKWith2Pays.xml")
      client = DineroMailIpn::Client.new(:email => 'ernesto@ombushop.com',
                                          :account => '17128254',
                                          :pin => 'AYCN7IXDTM')
      response = client.consulta_pago(Date.new(2011,7,2), Date.new(2011,7,3))
      assert_equal "1", response.state
      assert_equal 2, response.payments.size
      assert response.ok?
      assert_equal response.state_description, "La consulta se realizó correctamente"
      assert !response.payments.empty?
      payment = response.payments.first
      assert_equal "juanperez@ombushop.com", payment["Trx_Email"]
      assert_equal "R163000000", payment["trx_id"]
      assert payment["Trx_Numbr"].nil?
      assert !payment.items.empty?
      item = payment.items.first
      assert_equal "SKU123", item["Item_Code"]
      assert_equal "68.00", item["Item_Payment"]
      assert item["item_quantity"].nil?
    end

    should "return Error for the query" do
      stub_get("/vender/ConsultaPago.asp?XML=1&Acount=123&Pin=UasdM&Email=ernesto%40ombushop.com&StartDate=20110702&EndDate=20110703",
               "ConsultaPagoErrorBadCredentials.xml")
      client = DineroMailIpn::Client.new(:email => 'ernesto@ombushop.com',
                                         :account => '123',
                                         :pin => 'UasdM')
      response = client.consulta_pago(Date.new(2011,7,2), Date.new(2011,7,3))
      assert_equal response.state, "2"
      assert response.error?
      assert_equal response.state_description, "Los valores son incorrectos para realizar la consulta"
    end

  end

  context "when I query for some transactions" do

    should "return a new report object" do
      stub_post("/Vender/Consulta_IPN.asp", "ConsultaTransacciones1-2Success.xml",
                  {:url => {:https => false}})

      client = DineroMailIpn::Client.new(:password => 'fuckingipnpasswordinplaintext', :account => '17128254')
      reporter = client.consulta_transacciones([1,2])
      assert reporter.kind_of?(DineroMailIpn::Reporter)
      assert_equal 2, reporter.reports.size
    end

  end

  context "when I query for a transactions" do

    should "return a new report object" do
      stub_post("/Vender/Consulta_IPN.asp", "ConsultaTransacciones1Success.xml",
                  {:url => {:https => false}})

      client = DineroMailIpn::Client.new(:password => 'fuckingipnpasswordinplaintext', :account => '17128254')
      reporter = client.consulta_transacciones([1])
      assert reporter.kind_of?(DineroMailIpn::Reporter)
      assert_equal 1, reporter.reports.size
    end

  end
end
