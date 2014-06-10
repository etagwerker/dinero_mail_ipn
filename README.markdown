# Dinero Mail IPN

[![Build Status](https://travis-ci.org/etagwerker/dinero_mail_ipn.png?branch=master)](https://travis-ci.org/etagwerker/dinero_mail_ipn) [![Code Climate](https://codeclimate.com/github/etagwerker/dinero_mail_ipn.png)](https://codeclimate.com/github/etagwerker/dinero_mail_ipn)

Ruby gem para consumir los métodos de IPN 1 y IPN 2 de [Dinero
Mail](http://dineromail.com)

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

Ver: [http://rubydoc.info/gems/dinero_mail_ipn](http://rubydoc.info/gems/dinero_mail_ipn)

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

Copyright (c) 2014 Ernesto Tagwerker

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
