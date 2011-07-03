# encoding: utf-8

require 'helper'
require 'dinero_mail_ipn'

class TestDineroMailIpn < Test::Unit::TestCase
  
  context "when I query the Dinero Mail API via GET" do
    
    should "return OK for the query with valid Pin and Account parameters" do
      stub_get("/vender/ConsultaPago.asp?XML=1&Acount=17128254&Pin=AYCN7IXDTM&Email=ernesto%40ombushop.com&StartDate=20110702&EndDate=20110703", 
               "ConsultaPagoOkWithoutCollections.xml")
      client = DineroMailIpn::Client.new(:email => 'ernesto@ombushop.com', :account => '17128254', :pin => 'AYCN7IXDTM')
      response = client.consulta_pago(Date.new(2011,7,2), Date.new(2011,7,3))
      assert_equal response.state, "1"
      assert_equal response.state_description, "La consulta se realizó correctamente"
    end
    
    should "return Error for the query" do 
      stub_get("/vender/ConsultaPago.asp?XML=1&Acount=123&Pin=UasdM&Email=ernesto%40ombushop.com&StartDate=20110702&EndDate=20110703", 
               "ConsultaPagoErrorBadCredentials.xml")      
      client = DineroMailIpn::Client.new(:email => 'ernesto@ombushop.com', :account => '123', :pin => 'UasdM')
      response = client.consulta_pago(Date.new(2011,7,2), Date.new(2011,7,3))
      assert_equal response.state, "2"
      assert_equal response.state_description, "Los valores son incorrectos para realizar la consulta"
    end

  end
end