begin
  require 'nokogiri'  
rescue LoadError
  require 'rubygems'
  retry
end
require 'date'

Nokogiri::PLIST_LOADING = "1"

Nokogiri::XML::Node.send(:define_method, :to_plist) {Nokogiri::PList::Parser.parse(self)}
String.send(:define_method, :to_plist) {Nokogiri::PList(self)}

require File.join(File.dirname(__FILE__), 'nokogiri', 'plist', 'generator')
require File.join(File.dirname(__FILE__), 'nokogiri', 'plist', 'parser')
require File.join(File.dirname(__FILE__), 'nokogiri', 'plist')

Nokogiri::PLIST_LOADING.gsub!("1", "0")

