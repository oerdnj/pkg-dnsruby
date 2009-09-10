#--
#Copyright 2007 Nominet UK
#
#Licensed under the Apache License, Version 2.0 (the "License");
#you may not use this file except in compliance with the License.
#You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
#Unless required by applicable law or agreed to in writing, software
#distributed under the License is distributed on an "AS IS" BASIS,
#WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#See the License for the specific language governing permissions and
#limitations under the License.
#++
require 'test/unit'
require 'dnsruby'
require 'net/ftp'
include Dnsruby

class TestAuth < Test::Unit::TestCase
  def test_auth
    # @TODO@ Test that we can resolve frobbit.se securely
    Dnsruby::PacketSender.clear_caches
    dlv_key = RR.create("dlv.isc.org. IN DNSKEY 257 3 5 BEAAAAPHMu/5onzrEE7z1egmhg/WPO0+juoZrW3euWEn4MxDCE1+lLy2 brhQv5rN32RKtMzX6Mj70jdzeND4XknW58dnJNPCxn8+jAGl2FZLK8t+ 1uq4W+nnA3qO2+DL+k6BD4mewMLbIYFwe0PG73Te9fZ2kJb56dhgMde5 ymX4BI/oQ+cAK50/xvJv00Frf8kw6ucMTwFlgPe+jnGxPPEmHAte/URk Y62ZfkLoBAADLHQ9IrS2tryAe7mbBZVcOwIeU/Rw/mRx/vwwMCTgNboM QKtUdvNXDrYJDSHZws3xiRXF1Rf+al9UmZfSav/4NWLKjHzpT59k/VSt TDN0YUuWrBNh")
    Dnssec.add_dlv_key(dlv_key)
#Dnssec.load_itar
    r = Dnsruby::Recursor.new
#    Dnsruby::TheLog.level = Logger::DEBUG
    ret = r.query("frobbit.se", Dnsruby::Types.A)
    print ret
    assert(ret.security_level == Message::SecurityLevel::SECURE)
    print "Done frobbit A record\n"
    ret = r.query("frobbit.se", Dnsruby::Types.MX)
    print ret
    assert(ret.security_level == Message::SecurityLevel::SECURE)
        ret = r.query("ns2.nic.se", Dnsruby::Types.A)
    print ret
    assert(ret.security_level == Message::SecurityLevel::SECURE)
        ret = r.query("nic.se", Dnsruby::Types.NS)
    print ret
    assert(ret.security_level == Message::SecurityLevel::SECURE)
        ret = r.query("ns3.nic.se", Dnsruby::Types.A)
    print ret
    assert(ret.security_level == Message::SecurityLevel::SECURE)

  end

end
