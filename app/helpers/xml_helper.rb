class String
  def to_bytes(precision = 0, exact = true, truncate = true)
    if self.to_f/(exact ? 1048576 : 1000000) >= (exact ? 1024 : 1000)
      sprintf("%.#{precision}f", truncate ? yikes((exact ? 1073741824 : 1000000000), precision) : self.to_f/(exact ? 1073741824 : 1000000000)) + "GB"
    else
      sprintf("%.0f", self.to_f/(exact ? 1048576 : 1000000)) + "MB"
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
      sprintf("%.2f", yikes(1000000000, 2)) + "GHz" #truncate...
    else
      sprintf("%.0f", self.to_f/1000000) + "MHz"
    end
  end

  #######
  private
  #######

  def yikes(divide_by, precision) #divides and then truncates.
    return ((((self.to_f/divide_by)*(10**precision)).to_i).to_f)/(10**precision)
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
  def find_the_biggest(foreach_xpath, value_xpath, get_rid_of = "", &block)
    value = 0.0
    xpath_foreach(foreach_xpath) do
      if (this_value = xpath_value_of(value_xpath).gsub(get_rid_of, "").to_f) > value
        value = this_value
      end
    end
    if value != 0.0
      return yield(value)
    else
      return nil
    end
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
    what_was_got = File.basename(what_to_get)
    if what_was_got[0] == '@'[0]
      remove_attribute(nodes, what_was_got.sub(/@/, ""))
    else
      remove_tag(nodes, what_was_got)
    end
  end
end
