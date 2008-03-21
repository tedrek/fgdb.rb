module ReportsHelper
# I can describe this file in one word: ugly
# it needs a little work done on it...
  def load_xml
    require 'rexml/document'
    @this_thing = REXML::Document.new(File.open('/home/ryan52/my_xml').read) #use a file based on id or from db
    stylesheet_link_tag "fgss"
  end
  def remove_tag(s, tag)#needs a new name...replace all 'tag's with the right word
    s.to_s.gsub(/<#{tag}\b[^>]*>(.*?)<\/#{tag}>/, '\1')
    #   s.to_s.match(/<#{tag}\b[^>]*>(.*?)<\/#{tag}>/)[1] #might be better...
  end
  def xpath_if(what_to_look_for)
    @this_thing.elements.to_a(what_to_look_for)[0]
  end
  def xpath_foreach(xpath_thing)
    @this_thing.each_element(xpath_thing) { |this_thing|
      old_value=@this_thing
      @this_thing=this_thing
      yield
      @this_thing=old_value #use a better variable name for this too...replace this_thing with something better
    }
  end
  def xpath_value_of(what_to_get, put_me_before = nil, put_me_after = nil)
      if xpath_if(what_to_get)
        "#{put_me_before}#{remove_tag(@this_thing.elements.to_a(what_to_get)[0], what_to_get)}#{put_me_after}"
      else
        nil
      end
  end
end
