class HtmlTag
  attr_accessor :children, :attrs, :content
  attr_reader :tag
  def initialize(ptag, pattrs = {}, pchildren = [], pcontent = "")
    @children = pchildren
    @attrs = pattrs
    @content = pcontent
    @tag = ptag
  end

  def to_s
    str = '<'.html_safe
    str << tag.html_safe
    str << ' ' if attrs.count > 0
    str << attrs.map{|n,v| %Q!#{n}="#{v}"!}.join(' ').html_safe
    str << '>'.html_safe
    str << children.map {|i| ERB::Util.html_escape(i.to_s)}.join("\n").html_safe
    str << content
    str << "</#{tag}>".html_safe
    return str
  end
end
