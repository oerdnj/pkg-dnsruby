require 'rubygems'
SPEC = Gem::Specification.new do |s|
  s.name = "dnsruby"
  s.version = "1.36"
  s.authors = ["AlexD"]
  s.email = "alexd@nominet.org.uk"
  s.homepage = "http://rubyforge.org/projects/dnsruby/"
  s.rubyforge_project = "dnsruby"
  s.platform = Gem::Platform::RUBY
  s.summary = "Ruby DNS implementation"
  candidatestest = Dir.glob("test/**/*")
  candidateslib = Dir.glob("lib/**/*")
  candidatesdoc = Dir.glob("html**/*")
  candidatesdemo = Dir.glob("demo/**/*")
   candidates = candidatestest + candidateslib + candidatesdoc + candidatesdemo
  s.files = candidates.delete_if do |item|
                      item.include?("CVS") || item.include?("rdoc") ||
                         item.include?("svn")
                end
  s.autorequire="dnsruby"
  s.test_file = "test/ts_offline.rb"
  s.has_rdoc = true
  s.extra_rdoc_files = ["DNSSEC", "EXAMPLES", "README", "EVENTMACHINE"]
end

