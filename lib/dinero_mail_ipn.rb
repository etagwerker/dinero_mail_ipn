# encoding: utf-8

require 'httparty'
require 'nokogiri'

Dir[File.join(File.dirname(__FILE__),'dinero_mail_ipn', '*')].each {|file| require file }

module DineroMailIpn

  # # Cliente para Dinero Mail API (v1 y v2)
  #
  # Cliente para consumir los métodos de la API IPN v1 y v2.
  #
  # ## Cliente para IPN v1
  #
  #     DineroMailIpn::Client.new(:email => 'EMAILPRUEBA@gmail.com', :account => '17128254', :pin => 'AYCN7IXDTM')
  #
  # ## Cliente para IPN v2
  #
  #     DineroMailIpn::Client.new(:email => 'EMAILPRUEBA@gmail.com',
  #       :account => '17128254', :pin => 'AYCN7IXDTM', :password => 'ipnv2password')
  #
  # ## Paises
  #
  # Por default el Cliente se crea para una cuenta de Argentina. Para consultar la API de una cuenta en otro país:
  #
  #     DineroMailIpn::Client.new(:email => 'EMAILPRUEBA@gmail.com',
  #       :account => '17128254', :pin => 'AYCN7IXDTM', :pais => 'brasil')
  #
  # ### Posibilidades
  #
  # * 'argentina'
  # * 'chile'
  # * 'brasil'
  # * 'mexico'
  #
  # @see Client#initialize
  class Client
    include HTTParty
    format :xml
    attr_reader :email, :account, :pin, :pais, :password

    # País por default para consultas
    DEFAULT_COUNTRY = 'argentina'

    # @param [Hash] opts opciones para crear la instancia
    # @option opts [String] :email Email de la cuenta de Dinero Mail
    # @option opts [String] :account Número de cuenta de Dinero Mail (sin /)
    # @option opts [String] :pin PIN de la cuenta de Dinero Mail
    # @option opts [String] :password Contraseña para consultas de IPN v2
    # @option opts [String] :pais Pais de la cuenta. Por default: 'argentina'
    def initialize(opts)
      @email = opts[:email]
      @account = opts[:account]
      @pin = opts[:pin]
      @password = opts[:password]
      @pais = opts[:pais] || DEFAULT_COUNTRY
    end

    # Devuelve una {ConsultaPagoResponse}.
    #
    # @param [Date] Comienzo del período
    # @param [Date] Fin del período
    # @return [ConsultaPagoResponse] Respuesta
    def consulta_pago(start_date, end_date)
      params = default_params.merge({:StartDate => format_date(start_date), :EndDate => format_date(end_date)})
      response = self.class.get("https://#{@pais}.dineromail.com/vender/ConsultaPago.asp", :query => params)
      ConsultaPagoResponse.new(
        response.parsed_response)
    end

    # Devuelve un {String} con formato YYYYMMDD. (Por ej.: "20110201")
    #
    # @param [Date] Una fecha
    # @return [String] Fecha en formato Dinero Mail
    def format_date(a_date)
      a_date.strftime("%Y%m%d")
    end

    # Devuelve un objeto [Reporter] con un array de objetos tipo [Report].
    #
    # Los objetos de tipo [Report] están asociados a los ID de transacciones.
    #
    # Ejemplo:
    #
    #     client.consulta_transacciones([1,2])
    #
    # @param [Array] Array de transacciones
    #
    # @return [Reporter] Con todos los [Report] correspondientes
    def consulta_transacciones(transacciones = [])
      xml_builder = Nokogiri::XML::Builder.new do |xml|
        xml.REPORTE {
          xml.NROCTA @account
          xml.DETALLE {
            xml.CONSULTA {
              xml.CLAVE @password
              xml.TIPO 1
              xml.OPERACIONES {
                transacciones.each do |transaction_id|
                  xml.ID transaction_id
                end
              }
            }
          }
        }
      end
      body = xml_builder.to_xml
      body.sub!("<?xml version=\"1.0\"?>", "")
      body.gsub!(/\s/, '')

      response = self.class.post("http://#{@pais}.dineromail.com/Vender/Consulta_IPN.asp", :body => "DATA=#{body}",
                                :headers => {"Content-type" => "application/x-www-form-urlencoded", "Content-length" => "#{body.length}" }).response.body
      DineroMailIpn::Reporter.new(response)
    end

    private

    def default_params
      {:XML => 1, :Acount => @account, :Pin => @pin, :Email => @email}
    end
  end

end
