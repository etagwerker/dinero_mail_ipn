# encoding: utf-8

# Clase que agrega información de valor 
# para entender la respuesta de Dinero Mail IPN
# 
# Acorde a la documentación en resources/IPN_es.pdf
# Por ahora está solo en castellano. 
# 
# Ejemplos:
# > response = ConsultaPagoResponse.new({"Report"=>{"Email"=>"ernesto@ombushop.com", "Acount"=>"17128254", "Pin"=>nil, "StartDate"=>"20110603", "EndDate"=>"20110703", "XML"=>"1", "State"=>"1", "Pays"=>nil, "Collections"=>nil, "Tickets"=>nil, "Receptions"=>nil, "Retreats"=>nil, "Credits"=>nil, "Debits"=>nil}})
# > response.state
# => 2
# > response.state_description
# => "Los valores son incorrectos para realizar la consulta"

# TODO: 
# Más adelante se podría:
# * Agregar soporte para otros idiomas. 
# * Agregar más métodos de 'negocio' que tengan métodos útiles. 
# =>  Por ahora las collections de la consulta solo se pueden consultar por un hash (response.hash)


module DineroMailIpn
  
  class ConsultaPagoResponse
  
    attr_accessor :hash

    STATE_DESCRIPTIONS = {0 => 'Los parámetros no respetan el formato requerido', 1 => 'La consulta se realizó correctamente', 2 => 'Los valores son incorrectos para realizar la consulta'}
  
    # Crea una ConsultaPagoResponse usando un hash
    # en base a la respuesta de Dinero Mail
    # Por ejemplo: 
    # > ConsultaPagoResponse.new({"Report"=>{"Email"=>"ernesto@ombushop.com", "Acount"=>"17128254", "Pin"=>nil, "StartDate"=>"20110603", "EndDate"=>"20110703", "XML"=>"1", "State"=>"1", "Pays"=>nil, "Collections"=>nil, "Tickets"=>nil, "Receptions"=>nil, "Retreats"=>nil, "Credits"=>nil, "Debits"=>nil}})
    def initialize(_hash)
      self.hash = _hash
    end
  
    # Devuelve el estado de la respuesta
    # Posibilidades: "0", "1" o "2". 
    # Tira MalformedResponseError si no encuentra /Report/State
    # en la respuesta de Dinero Mail
    def state
      begin
        self.hash["Report"]["State"]
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