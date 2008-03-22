module ReportsHelper
# I can describe this file in one word: ugly
# it needs a little work done on it...
  def load_xml
    require 'rexml/document'
    @this_thing = REXML::Document.new(@report.lshw_output)
    nil
  end
  def remove_tag(s, tag)#needs a new name...replace all 'tag's with the right word
    s.to_s.gsub(/<#{tag}\b[^>]*>(.*?)<\/#{tag}>/, '\1')
    #   s.to_s.match(/<#{tag}\b[^>]*>(.*?)<\/#{tag}>/)[1] #might be better...
  end
  def xpath_if(what_to_look_for)
    REXML::XPath.match(@this_thing, what_to_look_for)[0]
  end
  def xpath_foreach(xpath_thing)
    @this_thing.each_element(xpath_thing) {|this_thing|
      old_value=@this_thing
      @this_thing=this_thing
      yield
      @this_thing=old_value #use a better variable name for this too...replace this_thing with something better
    }
  end
  def whats_in_this_thing(what_to_get)
    string=REXML::XPath.match(@this_thing, what_to_get)[0]
    if what_to_get[0]=='@'
      string #we are good with just this
    else
      remove_tag(string, what_to_get) #theres a tag around it...remove it please!
    end
  end
  #TODO: make a xpath_numerical or something like that
  def xpath_value_of(what_to_get, put_me_before = nil, put_me_after = nil)
      if xpath_if(what_to_get)
        "#{put_me_before}#{whats_in_this_thing(what_to_get)}#{put_me_after}"
      else
        "Unknown"
      end
  end
end
