# pass name if you only need info about a specific gem.
if name = params['name']
  puts Gem::Dependency.new(name).to_spec
  exit
end

# otherwise we'll output a html table with all installed gems and their versions
require 'cgi'

def h(s) CGI.escapeHTML(s.to_s) end

puts "<table>"
puts "  <tbody>"
puts "    <tr><td>Ruby</td><td>#{h RUBY_DESCRIPTION}</td></tr>"
puts "    <tr><td colspan='2'>Installed Gems</td></tr>"
Gem::Specification.each do |spec|
  puts "    <tr><td>#{h spec.name}</td><td>#{h spec.version}</td></tr>"
end
puts "  </tbody>"
puts "</table>"
