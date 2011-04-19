require 'httparty'

module DineroMailIpn
  class Client
    include HTTParty
    format :xml
    attr_reader :email, :account, :pin, :pais

    DEFAULT_PAIS = 'argentina'
    
    def initialize(opts)
      @email = opts[:email]
      @account = opts[:account]
      @pin = opts[:pin]
      @pais = opts[:pais] || DEFAULT_PAIS
    end

    # devuelve una response
    def consulta_pago(start_date, end_date)
      params = default_params.merge({:StartDate => format_date(start_date), :EndDate => format_date(end_date)})
      self.class.get "https://#{@pais}.dineromail.com/vender/ConsultaPago.asp", :query => params
    end
    
    def default_params
      debugger
      {:XML => 1, :Acount => @account, :Pin => @pin, :Email => @email}
    end
    
    # formatea una date a 20110201
    def format_date(a_date)
      a_date.strftime("%Y%m%d")
    end
  end

end

  # DineroMail::Ipn.consulta_ipn()