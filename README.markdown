# Dinero Mail IPN Gem

Ruby gem para consumir los metodos de IPN 1 y IPN 2. 

## Instalación

    gem install dinero_mail_ipn

### Bundler

    gem 'dinero_mail_ipn'
    
## Uso

    require 'dinero_mail_ipn'

### IPN v1
    > client = DineroMailIpn::Client.new(:email => 'EMAILPRUEBA@gmail.com', :account => '17128254', :pin => 'AYCN7IXDTM')
    => #<DineroMailIpn::Client:0x5e3120 @email="EMAILPRUEBA@gmail.com", @account="17128254", @pin="AYCN7IXDTM", @password=nil, @pais="argentina">    
    > response = client.consulta_pago(Date.today.prev_month, Date.today)
     => #<DineroMailIpn::ConsultaPagoResponse:0x5f9600 @hash={"Report"=>{"Email"=>"EMAILPRUEBA@gmail.com", "Acount"=>"17128254", "Pin"=>nil, "StartDate"=>"20110603", "EndDate"=>"20110703", "XML"=>"1", "State"=>"1", "Pays"=>nil, "Collections"=>nil, "Tickets"=>nil, "Receptions"=>nil, "Retreats"=>nil, "Credits"=>nil, "Debits"=>nil}}> 
    > response.state
     => "1" 
    > response.state_description
     => "La consulta se realizó correctamente" 
    > response.hash["Pays"]
     => nil     

### IPN v2
    c = DineroMailIpn::Client.new(:account => '09813581', :password => 'mipassword)
    c.consulta_transacciones("31548", "XA5547")
    # Response
    {"REPORTE"=>{"ESTADOREPORTE"=>"8", "DETALLE"=>{"OPERACIONES"=>nil}}}

## Roadmap

* Agregar más información a los wrappers de cada respuesta de Dinero Mail. Así facilitar el consumo de la API de Dinero Mail IPN. 
* Agregar más tests que testeen las posibles respuestas de Dinero Mail IPN
* Agregar más documentación y ejemplos

## Patches/Pull Requests

* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a
  future version unintentionally.
* Commit, do not mess with Rakefile, version, or history.
  (if you want to have your own version, that is fine but
   bump version in a commit by itself I can ignore when I pull)
* Send me a pull request. Bonus points for topic branches.

## Licencia

Dinero Mail IPN is released under the MIT license.