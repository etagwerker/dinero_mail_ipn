# encoding: utf-8

module DineroMailIpn

  # # Payment (IPN v1)
  #
  # Cada {ConsultaPagoResponse} puede tener 0 o muchos pagos,
  # dependiendo del período. 
  #
  # Un pago puede tener muchos objetos de tipo {Item} describiendo los
  # artículos pagados.
  #
  # Para acceder a estos objetos:
  #
  #     response.payments
  #
  # Para acceder a los atributos de cada pago: 
  #
  #     payment["Trx_Email"]
  #     # ernesto@ombushop.com
  #     payment["trx_id"]
  #     # 12345441
  #
  # @see ConsultaPagoResponse#payments
  class Payment

    # @private
    def initialize(hash)
      @hash = hash
    end

    # Devuelve un {String} o nil
    # @return [String]
    def [](key)
      @hash[key]
    end

    # Devuelve un {Array} de objetos tipo {Item}
    # @return [Array]
    def items
      return @items if @items

      @items = []

      unless @hash["Items"].nil?
        @hash["Items"].each do |key, hash|
          @items << Item.new(hash)
        end
      end

      return @items
    end
  end

end
