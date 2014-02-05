# encoding: UTF-8
module DineroMailIpn

  # # Reporte por transacción
  #
  # Nos dice el estado de la transacción, el ID, quién pagó, el número
  # de transacción, la fecha y el monto de la misma.
  #
  # ## Posibles estados
  #
  # * Pendiente (Report::PENDING_STATUS)
  # * Cancelado (Report::CANCELLED_STATUS)
  # * Completado (Report::COMPLETED_STATUS)
  #
  class Report

    # Posibles estados de transacciones
    PENDING_STATUS = 1
    COMPLETED_STATUS = 2
    CANCELLED_STATUS = 3

    attr_reader :id, :amount, :state, :payer_email, :numtransaction, :date

    # @param [Hash] opts opciones para crear la instancia
    # @option opts [String] :id ID de transacción
    # @option opts [String] :amount Monto de transacción (Por ej. "12.45")
    # @option opts [String] :state Uno de los posibles estados
    def initialize(opts)
      @id = opts[:id]
      @amount = opts[:amount]
      @state = opts[:state].to_i
      @payer_email = opts[:payer_email]
      @numtransaction = opts[:numtransaction]
      @date          = opts[:date]
    end

    # Devuelve true si la transacción fue completada
    #
    # @return [Boolean]
    def transaction_completed?
      @state == COMPLETED_STATUS
    end

    # Devuelve true si la transacción está pendiente
    #
    # @return [Boolean]
    def transaction_pending?
      @state == PENDING_STATUS
    end

    # Devuelve true si la transacción fue cancelada
    #
    # @return [Boolean]
    def transaction_cancelled?
      @state == CANCELLED_STATUS
    end

  end
end
