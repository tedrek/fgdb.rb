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
    str << attrs.map{|n,v| %Q!#{n}="#{v}"!}.join(' ') + '>'.html_safe +
      children.map{|x| x.to_s}.join("\n") +
      content.to_s +
      "</#{tag}>".html_safe
    return str
  end
end
