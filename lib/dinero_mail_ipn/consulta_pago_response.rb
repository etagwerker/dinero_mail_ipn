# encoding: utf-8
module DineroMailIpn

  # # Respuesta a Consulta IPN v1
  #
  # Clase que agrega información de valor para entender la respuesta de Dinero Mail IPN v1.
  #
  # Para más información ver:
  # [https://github.com/etagwerker/dinero_mail_ipn/blob/master/resources/IPN_es.pdf](https://github.com/etagwerker/dinero_mail_ipn/blob/master/resources/IPN_es.pdf)
  #
  # ## Ejemplos:
  #
  #     response = ConsultaPagoResponse.new({"Report"=>{"Email"=>"ernesto@ombushop.com", "Acount"=>"17128254",
  #       "Pin"=>nil, "StartDate"=>"20110603", "EndDate"=>"20110703", "XML"=>"1",
  #       "State"=>"1", "Pays"=>nil, "Collections"=>nil, "Tickets"=>nil, "Receptions"=>nil,
  #       "Retreats"=>nil, "Credits"=>nil, "Debits"=>nil}})
  #     response.state
  #     # 1
  #     response.ok?
  #     # true
  #     response.state_description
  #     # 'La consulta se realizó correctamente'
  #
  # ## Nota
  #
  # Por ahora las collections de la consulta solo se pueden consultar por un hash (response.dm_hash)
  #
  # ## TODO
  #
  # Agregar más métodos de 'negocio' que tengan métodos útiles.
  class ConsultaPagoResponse

    attr_accessor :dm_hash

    STATE_DESCRIPTIONS = {0 => 'Los parámetros no respetan el formato requerido', 1 => 'La consulta se realizó correctamente', 2 => 'Los valores son incorrectos para realizar la consulta'}

    # Crea una ConsultaPagoResponse usando un hash en base a la respuesta de Dinero Mail.
    #
    # Por ejemplo:
    #
    #     ConsultaPagoResponse.new({"Report"=>{"Email"=>"ernesto@ombushop.com", "Acount"=>"17128254",
    #       "Pin"=>nil, "StartDate"=>"20110603", "EndDate"=>"20110703", "XML"=>"1",
    #       "State"=>"1", "Pays"=>nil, "Collections"=>nil, "Tickets"=>nil, "Receptions"=>nil,
    #       "Retreats"=>nil, "Credits"=>nil, "Debits"=>nil}})
    def initialize(_hash)
      self.dm_hash = _hash
    end

    # Devuelve true si la respuesta no devolvió error
    #
    # @return [Boolean]
    def ok?
      state == "1"
    end

    # Devuelve true si la respuesta devolvió error
    #
    # @return [Boolean]
    def error?
      !ok?
    end

    # Devuelve un {Array} de objetos tipo {Payment}
    #
    # @return [Array] Objetos de tipo {Payment}
    def payments
      return @payments if @payments

      @payments = []
      begin
        if dm_hash["Report"]["Pays"]
          pays = dm_hash["Report"]["Pays"]["Pay"]

          if pays
            case pays.class.name
            when "Hash"
              @payments << Payment.new(pays)
            when "Array"
              pays.each { |pay| @payments << Payment.new(pay) }
            end
          end
        end
      rescue Exception => e
        raise MalformedResponseError.new("Error procesando pagos: #{e.message}")
      end
      @payments
    end

    # Devuelve el código de estado de la respuesta.
    #
    # Posibilidades: "0", "1" o "2".
    #
    # @raise [MalformedResponseError] Si la respuesta no tiene /Report/State
    def state
      begin
        self.dm_hash["Report"]["State"]
      rescue Exception => e
        raise MalformedResponseError.new("No se encontró /Report/State en el XML de respuesta")
      end
    end

    # Devuelve la descripción del código de respuesta
    # según la documentación
    def state_description
      STATE_DESCRIPTIONS[state.to_i]
    end

  end

end
