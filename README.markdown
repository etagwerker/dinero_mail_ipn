# Dinero Mail IPN Gem

Ruby gem para consumir los metodos de IPN 1 y IPN 2. 

## Instalación

    gem install dinero_mail_ipn

### Bundler

    gem 'dinero_mail_ipn'
    
## Uso

    require 'dinero_mail_ipn'

### IPN v1
    c = DineroMailIpn::Client.new(:email => 'EMAILPRUEBA@gmail.com', :account => '09813581', :pin => 'URJYRLU2PP')
    c.consulta_pago(before,now) # before y now son Dates
    # Response
    {"Report"=>{"Email"=>"EMAILPRUEBA@gmail.com", "Acount"=>"09813581", "Pin"=>"URJYRLU2PP", "StartDate"=>"20110419", "EndDate"=>"20110419", "XML"=>"1", "State"=>"2", "Pays"=>nil, "Collections"=>nil, "Tickets"=>nil, "Reception"=>nil, "Retreats"=>nil, "Credits"=>nil, "Debits"=>nil}} 

### IPN v2
    c = DineroMailIpn::Client.new(:account => '09813581', :password => 'mipassword)
    c.consulta_transacciones("31548", "XA5547")
    # Response
    {"REPORTE"=>{"ESTADOREPORTE"=>"8", "DETALLE"=>{"OPERACIONES"=>nil}}}

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