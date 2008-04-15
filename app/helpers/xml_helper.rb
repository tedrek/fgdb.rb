class String
  def to_bytes(precision = 0)
    if self.to_f/1048576 >= 1024
      sprintf("%.#{precision}f", self.to_f/1073741824) + "GB"
    else
      sprintf("%.0f", self.to_f/1048576) + "MB"
    end
  end

  def to_bitspersecond
    if self.to_i >= 1000
      (self.to_i/1000).to_s + "Gbps"
    else
      self + "Mbps"
    end
  end
  
  def to_hertz
    if self.to_f/1000000 >= 1000
      sprintf("%.2f", self.to_f/1000000000) + "GHz"
    else
      sprintf("%.0f", self.to_f/1000000) + "MHz"
    end
  end
end


module XmlHelper
  ######
  public
  ######

  def load_xml(xml)
    require 'xml/libxml'
    begin
      raise if xml.empty?
      @this_thing = XML::Parser.string(xml).parse
      return true
    rescue
      return false
    end
    nil
  end
  def xpath_if(what_to_look_for)
    if get_matches(what_to_look_for).first
      true
    else
      false
    end    
  end
  def xpath_foreach(xpath_thing)
    for this_thing in get_matches(xpath_thing) 
      old_value=@this_thing
      @this_thing=this_thing
      yield
      @this_thing=old_value
    end
    nil
  end
  def xpath_value_of(what_to_get)
    if xpath_if(what_to_get)
      whats_in_this_thing(what_to_get)
    else
      "Unknown"
    end
  end
  def find_the_biggest()
    
  end

  #######
  private
  #######

  def get_matches(what_to_match)
    @this_thing.find(what_to_match).to_a
  end
  def remove_tag(s, tag)
    s.to_s.gsub(/<#{tag}\b[^>]*>(.*?)<\/#{tag}>/, '\1')
  end
  def remove_attribute(s, attr)
    s.to_s.gsub(/#{attr}=(["'])([^\1]*)\1/, '\2')
  end
  def whats_in_this_thing(what_to_get)
    nodes=get_matches(what_to_get).first
    if what_to_get[0]=='@'[0]
      remove_attribute(nodes, what_to_get.gsub(/@/, ''))
    else
      remove_tag(nodes, what_to_get.gsub(/(.*)\//, ''))
    end
  end
end
