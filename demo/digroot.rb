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

#= NAME
#
#digitar - Ruby script to perform DNS queries, validated against the IANA TAR
#(trust anchor repository).
#
#= SYNOPSIS
#
#digitar name [ type [ class ] ]
#
#= DESCRIPTION
#
#Performs a DNS query on the given name.  The record type
#and class can also be specified; if left blank they default
#to A and IN. The program firstly performs the requested DNS
# query. The response is then validated
#- the ITAR is searched for the keys of the closest ancestor
#of the query name, and the chain of trust is followed to prove
#that the DNSSEC records are correct, or that we do not expect the
#response to be signed.
#
#= AUTHOR
#
#Michael Fuhr <mike@fuhr.org>
#Alex D <alexd@nominet.org.uk>

require 'rubygems'
require 'dnsruby'
include Dnsruby

raise RuntimeError, "Usage: #{$0} name [ type [ class ] ]\n" unless (ARGV.length >= 1) && (ARGV.length <= 3)

#hints = ["208.77.188.32", "204.61.216.37", "208.78.70.92", "204.13.250.92", " 208.78.71.92", "204.13.251.92"]
hints = ["root.iana.org"]
r = Resolver.new({:nameserver => hints})
res = Dnsruby::Recursor.new(r)
res.hints = hints

key = RR.create(". 86400 IN DNSKEY 257 3 5 AwEAAff8EiNa/S3wovNzPUmuBqe1pSjnNoen
                                        cXDNMpmjTgngGMPct+8KDKxM6FwvPSRx15gN
                                        RyRQfzSPU0WshDNkBV2TMtVpzqn/dsurbmTo
                                        ixRzLyLK2Kd2adg5o5yS/gaTgCo0HVBmIruS
                                        N3FVI2ugCWJBFLkFGHLvMJ0BTSYVqWGwQIzp
                                        EPKCbKN+L9nrLcvJRCWG59Yq6BUsSEKlzSK3
                                        jMhYQs6y5IiCGAVol+3VyjN93/lXkeUG6u7d
                                        lQsyiY9fxfeUvmn004y0TjAgjZqdwKZB0K9M
                                        A7qcALG3Tw2TXEdQsn9aY3DzNii3YEBidzER
                                        mY7n4hIUri1r59MnuNJq2x0=")

print " Key = #{key}, type = #{key.type}, name = #{key.name}\n"

Dnssec.add_trust_anchor(key)
Dnssec.add_trust_anchor(RR.create(". 86400 IN DNSKEY 257 3 5 AwEAAb+qUOkdZKCP0Qn/4TxJy2XD07xOckKj
                                        wwAHOE/Hn3rLGy0RpmVYCOrmJbVtfyC6i8SQ
                                        sRRKj6YUVlNg7EJ9gjK6rTiDlYMxSc0hFsoG
                                        I8qfAfmsjwClVh86rSIJvruvbcRsQURp/gvJ
                                        EdOaEHlA3JEIHS3cRR5AjKeF1IQdsGYtJMBM
                                        2VMtrgHKgOPZjzfM6bPyg+H9uMBwOm2HkSiE
                                        geAw2vXEHp0eNM2sOxUQMYYPkoywa28oxP4v
                                        dUI7ht4I8etlq3gNCEuBJjV4347ZQ0VHIwDw
                                        JSVmYBzc4f3REfEZS7h6fR33wPVQIw9NNi9p
                                        Cy7JRqzEGwHVft/re6SRqE0="))
#res.hints = hints
print "Trust anchors : #{Dnssec.trust_anchors}\n"
    Dnsruby::TheLog.level=Logger::DEBUG

name, type, klass = ARGV
type  ||= "A"
klass ||= "IN"
  
  begin
    answer = nil
    answer = res.query(name, type, klass)
    print answer
  rescue Exception => e
    print "query failed: #{e}\n"
  end
