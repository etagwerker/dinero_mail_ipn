module DineroMailIpn

  # La respuesta enviada desde Dinero Mail IPN tiene un formato inesperado.
  class MalformedResponseError < StandardError; end

end
