module XmlHelper
  def get_matches(what_to_match)
    @this_thing.find(what_to_match).to_a
  end
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
  def remove_tag(s, tag)
    s.to_s.gsub(/<#{tag}\b[^>]*>(.*?)<\/#{tag}>/, '\1')
  end
  def remove_attribute(s, attr)
    s.to_s.gsub(/#{attr}=(["'])([^\1]*)\1/, '\2')
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
  def whats_in_this_thing(what_to_get)
    nodes=get_matches(what_to_get).first
    if what_to_get[0]=='@'[0]
      remove_attribute(nodes, what_to_get.gsub(/@/, ''))
    else
      remove_tag(nodes, File.basename(what_to_get))
    end
  end
  def xpath_value_of(what_to_get)
    if xpath_if(what_to_get)
      whats_in_this_thing(what_to_get)
    else
      "Unknown"
    end
  end
end
