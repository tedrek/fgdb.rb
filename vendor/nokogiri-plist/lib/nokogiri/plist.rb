if !defined?(Nokogiri::PLIST_LOADING) || Nokogiri::PLIST_LOADING == "0"
  require File.join(File.dirname(__FILE__), '..', "nokogiri-plist")
else

module Nokogiri  
  
  class << self
    
    def PList(xml)
      Nokogiri::PList::Parser.parse(Nokogiri::XML(xml))
    end 
    
  end
  
end

end
