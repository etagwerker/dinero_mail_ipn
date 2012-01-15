# coding: UTF-8

module DineroMailIpn
  class Report
    
    # Transaction status list
    PENDING_STATUS = 1
    COMPLETED_STATUS = 2
    CANCELLED_STATUS = 3
    
    attr_reader :id, :amount
    
    def initialize(attributes)
      @id = attributes[:id]
      @amount = attributes[:amount]
      @state = attributes[:state]
    end
    
    def transaction_completed?
      @state == COMPLETED_STATUS
    end

    def transaction_pending?
      @state == PENDING_STATUS
    end

    def transaction_cancelled?
      @state == CANCELLED_STATUS
    end

  end
end