# encoding: utf-8

module DineroMailIpn

  # # Item (IPN v1)
  #
  # Cada {Payment} puede estar asociado con uno o muchos items. 
  #
  # Para acceder a estos objetos: 
  #
  #     payment.items
  #
  # Para acceder a los atributos de estos objetos:
  #
  #     item["Item_Code"]
  #     # "SKU123"
  #     item["Item_Payment"]
  #     # "68.00"
  #
  # @see Payment#items
  class Item

    # @private
    def initialize(hash)
      @hash = hash
    end

    # Devuelve un {String} o nil
    # @return [String]
    def [](key)
      @hash[key]
    end

  end
end
