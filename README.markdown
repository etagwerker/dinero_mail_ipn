# Dinero Mail IPN Gem

Ruby gem para consumir los métodos de IPN 1 y IPN 2.

## Instalación

    gem install dinero_mail_ipn

### Bundler

    gem 'dinero_mail_ipn'

## Uso

    require 'dinero_mail_ipn'

### IPN v1

Consulta de pagos en períodos de una semana. 

    client = DineroMailIpn::Client.new(:email => 'EMAILPRUEBA@gmail.com', :account => '17128254', :pin => 'AYCN7IXDTM')
    response = client.consulta_pago(Date.today - 7, Date.today)
    # #<DineroMailIpn::ConsultaPagoResponse:0x5f9600 @hash={"Report"=>{"Email"=>"EMAILPRUEBA@gmail.com",
    # "Acount"=>"17128254", "Pin"=>nil, "StartDate"=>"20110603", "EndDate"=>"20110703", "XML"=>"1", 
    # "State"=>"1", "Pays"=>nil, "Collections"=>nil, "Tickets"=>nil, "Receptions"=>nil, "Retreats"=>nil,
    # "Credits"=>nil, "Debits"=>nil}}>
    response.ok? 
    # true
    response.state_description
    # "La consulta se realizó correctamente"
    payment = response.payments.first
    payment["Trx_Payment"]
    # "108.98"

### IPN v2

Consulta de reportes para transacciones específicas.

    c = DineroMailIpn::Client.new(:account => '09813581', :password => 'mipassword')
    reporter = c.consulta_transacciones(["31548", "23123"])
    report = reporter.reports.first
    report.id
    # 1
    report.amount
    # 2999
    report.valid?
    # true

## Documentación

Ver: [http://rubydoc.info/github/etagwerker/dinero_mail_ipn/master/frames](http://rubydoc.info/github/etagwerker/dinero_mail_ipn/master/frames)

Si falta algo, por favor reportarlo como issue.

## Roadmap

* Agregar más tests que testeen las posibles respuestas de Dinero Mail IPN
* Agregar más documentación y ejemplos

## Patches/Pull Requests

Fork the project.

Make your feature addition or bug fix.

Add tests for it. This is important so I don't break it in a future version unintentionally.

Commit, do not mess with Rakefile, version, or history. (if you want to have your own version, that is fine but bump version in a commit by itself I can ignore when I pull)

Send me a pull request. Bonus points for topic branches.

## Licencia

Dinero Mail IPN is released under the MIT license.
