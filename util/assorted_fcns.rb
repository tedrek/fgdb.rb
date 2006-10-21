# interesting functions I wanted to save
module AssortedFcns

  # checkbox_collection
  # create a set of checkboxes for updating a habtm
  # relationship
  # source: http://exdolo.com/2006/8/8/habtm-checkbox-helper
  #
  # imagine you have a Role and User model with a habtm
  # relationship.
  # given an @user object for the current user and a collection
  # of all roles in @roles:
  #
  # checkbox_collection("user","role", @user, @roles.collect{|r| [r.title,r.id]})
  #
  # the collection parameter expects an array of arrays with the
  # label as the first member in an element array and it's value
  # as the last. 
  def checkbox_collection(objekt,method,instance,collection)
    m2m = instance.send("#{method}s".to_sym)
    name_string = "#{objekt}[#{method}_ids][]" 
    collection.map do |item|
      id_string = "#{objekt}_#{method}_#{item.last}" 
      tag_options = {
        "type" => "checkbox", 
        "name" => name_string,
        "id" => id_string,
        "value" => item.last
      }
      tag_options["checked"] = "checked" if m2m.collect{|a| a.id}.include?  item.last
      content_tag("li", tag("input", tag_options) + content_tag("label",item.first,"for" => id_string))
    end.join("\n")
  end 
end
