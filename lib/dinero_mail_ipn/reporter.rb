# encoding: UTF-8

module DineroMailIpn
  class Reporter

    # Report status list
    VALID_REPORT_STATUS = 1
    MALFORMED_REPORT_STATUS = 2
    INVALID_ACCOUNT_NUMBER_REPORT_STATUS = 3
    INVALID_PASSWORD_REPORT_STATUS = 4
    INVALID_REQUEST_TYPE_STATUS = 5
    INVALID_TRANSACTION_ID_REQUEST_STATUS = 6
    INVALID_PASSWORD_OR_ACCOUNT_NUMBER_REQUEST_STATUS = 7
    TRANSACTION_NOT_FOUND_REQUEST_STATUS = 8

    attr_reader :reports

    def initialize(xml_response)
      @doc = Nokogiri::XML(xml_response.downcase)
      @reports = build_reports
    end

    def valid?
      @doc.xpath("//estadoreporte").first.content.to_i == VALID_REPORT_STATUS
    end

    private

    def build_reports
      return [] if @doc.xpath("//operacion").empty?
      @doc.xpath("//operacion").map do |report_xml|
        DineroMailIpn::Report.new :id => report_xml.xpath("//id").text,
                                  :amount => report_xml.xpath("//monto").text.to_f,
                                  :state => report_xml.xpath("//estado").text,
                                  :payer_email => report_xml.xpath("//comprador").xpath("//email").text,
                                  :numtransaction => report_xml.xpath("//numtransaccion").text,
                                  :date => Chronic.parse(report_xml.xpath("//fecha").text)
      end
    end

  end
end

