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
require 'rubygems'
require 'test/unit'
require 'dnsruby'
include Dnsruby
class TestRrTest < Test::Unit::TestCase
  #Stimulus, expected response, and test name:
  
  TESTLIST =	[
  {	# 2-5
    :stim		=>	%<"">,
    :rdatastr	=>	%<"">,
    :char_str_list_r	=>	['',],
    :descr		=>	'Double-quoted null string',
  },
  {	# 6-9
    :stim		=>	%<''>,
    :rdatastr	=>	%<"">,
    :char_str_list_r	=>	['',],
    :descr		=>	'Single-quoted null string',
  },
  {	# 10-13
    :stim		=>	%<" \t">,
    :rdatastr	=>	%<" \t">,
    :char_str_list_r	=>	[ %< \t>, ],
    :descr		=>	'Double-quoted whitespace string',
  },
  {	# 14-17
    :stim		=>	%<noquotes>,
    :rdatastr	=>	%<"noquotes">,
    :char_str_list_r	=>	[ %<noquotes>, ],
    :descr		=>	'unquoted single string',
  },
  {	# 18-21
    :stim		=>	%<"yes_quotes">,
    :rdatastr	=>	%<"yes_quotes">,
    :char_str_list_r	=>	[ %<yes_quotes>, ],
    :descr		=>	'Double-quoted single string',
  },
  {	# 26-29
    :stim		=>	%<two tokens>,
    :rdatastr	=>	%<"two" "tokens">,
    :char_str_list_r	=>	[ %q|two|, %q|tokens|, ],
    :descr		=>	'Two unquoted strings',
  },
  # @TODO@ Why don't escaped quotes work?
  #    {	# 22-25
  #			:stim		=>	%<"escaped \" quote">,
  #			:rdatastr	=>	%<"escaped \" quote">,
  #			:char_str_list_r	=>	[ %<escaped " quote>, ],
  #			:descr		=>	'Quoted, escaped double-quote',
  #    },
  #    { # 30-33
  #			:stim		=> %<"missing quote>,
  #			:rdatastr    => %<>,
  #			:char_str_list_r	=>	[],
  #			:descr    	=> 'Unbalanced quotes work',
  #    }
  ]
  
  def test_RrTest
    #------------------------------------------------------------------------------
    # Canned data.
    #------------------------------------------------------------------------------
    
    name			= 'foo.example.com';
    klass			= 'IN';
    type			= 'TXT';
    ttl				= 43201;
    
    rr_base	= [name, ttl, klass, type, "    " ].join(' ')
    
    
    #------------------------------------------------------------------------------
    # Run the tests
    #------------------------------------------------------------------------------
    
    TESTLIST.each do |test_hr|
      assert( uut = RR.create(rr_base + test_hr[:stim]), 	
      test_hr[:descr] + " -- Stimulus " ) 
            
      assert_equal(test_hr[:rdatastr], uut.rdata_to_string(), 			
      test_hr[:descr] + " -- Response ( rdatastr ) " ) 
      
      list = uut.strings	
      
      assert_equal(test_hr[:char_str_list_r], list,
                   test_hr[:descr] +  " -- char_str_list equality"  ) 		
    end
    
    string1 = %<no>
    string2 = %<quotes>
    
    rdata = [string1.length].pack("C") + string1
    rdata += [string2.length].pack("C") + string2
    
    work_hash = {
      :name		=> name,
      :ttl		=> ttl,
      :class		=> klass,
      :type		=> type,
    }
    
    
    # Don't break RR.new_from_hash (e.i. "See the manual pages for each RR 
    # type to see what fields the type requires.").
    
    work_hash[:strings] = %<no quotes>
    
    uut = RR.create(work_hash)    
    assert( uut , 		# 30
    "RR.new_from_hash with txtdata -- Stimulus")
    assert_equal( uut.rdata_to_string() , %<"no" "quotes">, 		# 31
    "RR.new_from_hash with txtdata -- Response (rdatastr())")
    
    rr_rdata = MessageEncoder.new {|msg|
      uut.encode_rdata(msg)
    }.to_s
    assert( rr_rdata == rdata , "TXT.rr_rdata" )	# 32
    
    
  end
end
