require 'httparty'
require 'nokogiri'

# require all files in dinero_mail_ipn
Dir[File.join(File.dirname(__FILE__),'dinero_mail_ipn', '*')].each {|file| require file }

module DineroMailIpn
  class Client
    include HTTParty
    format :xml
    attr_reader :email, :account, :pin, :pais, :password

    DEFAULT_COUNTRY = 'argentina'
    
    def initialize(opts)
      @email = opts[:email]
      @account = opts[:account]
      @pin = opts[:pin]
      @password = opts[:password]
      @pais = opts[:pais] || DEFAULT_COUNTRY
    end

    # devuelve una response
    def consulta_pago(start_date, end_date)
      params = default_params.merge({:StartDate => format_date(start_date), :EndDate => format_date(end_date)})
      ConsultaPagoResponse.new(self.class.get("https://#{@pais}.dineromail.com/vender/ConsultaPago.asp", :query => params).parsed_response)
    end

    def default_params
      {:XML => 1, :Acount => @account, :Pin => @pin, :Email => @email}
    end
    
    # formatea una date a 20110201
    def format_date(a_date)
      a_date.strftime("%Y%m%d")
    end

    def consulta_transacciones(*transacciones)
      xml_builder = Nokogiri::XML::Builder.new do |xml|
        xml.REPORTE {
          xml.NROCTA @account
          xml.DETALLE {
            xml.CONSULTA {
              xml.CLAVE @password
              xml.TIPO 1
              xml.OPERACIONES {
                transacciones.each do |transaccion|
                  xml.ID transaccion
                end
              }
            }
          }
        }
      end
      body = xml_builder.to_xml
      body.sub!("<?xml version=\"1.0\"?>", "")
      body.gsub!(/\s/, '')

      self.class.post("http://#{@pais}.dineromail.com/Vender/Consulta_IPN.asp", :body => "DATA=#{body}", 
                       :headers => {"Content-type" => "application/x-www-form-urlencoded", "Content-length" => "#{body.length}" }).parsed_response
    end
  end

end
