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
    str = '<' + tag
    str << ' ' if attrs.count > 0
    str << attrs.map{|n,v| %Q!#{n}="#{v}"!}.join(' ') + '>' +
      children.map{|x| x.to_s}.join("\n") +
      content.to_s +
      "</#{tag}>"
    return str
  end
end
