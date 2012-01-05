# coding: UTF-8

module DineroMailIpn
  class Report

    # Report status list
    VALID_REPORT_STATUS = 1
    MALFORMED_REPORT_STATUS = 2
    INVALID_ACCOUNT_NUMBER_REPORT_STATUS = 3
    INVALID_PASSWORD_REPORT_STATUS = 4
    INVALID_REQUEST_TYPE_STATUS = 5
    INVALID_TRANSACTION_ID_REQUEST_STATUS = 6
    INVALID_PASSWORD_OR_ACCOUNT_NUMBER_REQUEST_STATUS = 7
    TRANSACTION_NOT_FOUND_REQUEST_STATUS = 8

    # Transaction status list
    PENDING_STATUS = 1
    COMPLETED_STATUS = 2
    CANCELLED_STATUS = 3

    def initialize(xml_response)
      @doc = Nokogiri::XML(xml_response.downcase)
    end

    def valid?
      @doc.xpath("//estadoreporte").first.content.to_i == VALID_REPORT_STATUS
    end

    def transaction_completed?
      @doc.xpath("//estado").first.content.to_i == COMPLETED_STATUS
    end

    def transaction_pending?
      @doc.xpath("//estado").first.content.to_i == PENDING_STATUS
    end

    def transaction_cancelled?
      @doc.xpath("//estado").first.content.to_i == CANCELLED_STATUS
    end

    def id
      @doc.xpath("//id").first.content.to_i
    end

    def amount
      @doc.xpath("//monto").first.content.to_i
    end
  end
end
