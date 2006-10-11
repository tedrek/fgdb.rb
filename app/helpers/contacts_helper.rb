module ContactsHelper
  include AjaxScaffold::Helper
  
  def num_columns
    scaffold_columns.length + 1 
  end
  
  def scaffold_columns
    [ 
      AjaxScaffold::ScaffoldColumn.new(Contact, 
        :name => 'is_organization'),
      AjaxScaffold::ScaffoldColumn.new(Contact, 
        :name => 'sort_name'),
      AjaxScaffold::ScaffoldColumn.new(Contact, 
        :name => 'first_name'),
      AjaxScaffold::ScaffoldColumn.new(Contact, 
        :name => 'middle_name'),
      AjaxScaffold::ScaffoldColumn.new(Contact, 
        :name => 'surname'),
      AjaxScaffold::ScaffoldColumn.new(Contact, 
        :name => 'organization'),
      AjaxScaffold::ScaffoldColumn.new(Contact, 
        :name => 'extra_address'),
      AjaxScaffold::ScaffoldColumn.new(Contact, 
        :name => 'address'),
      AjaxScaffold::ScaffoldColumn.new(Contact, 
        :name => 'city'),
      AjaxScaffold::ScaffoldColumn.new(Contact, 
        :name => 'state_or_province'),
      AjaxScaffold::ScaffoldColumn.new(Contact, 
        :name => 'postal_code'),
      AjaxScaffold::ScaffoldColumn.new(Contact, 
        :name => 'country'),
      AjaxScaffold::ScaffoldColumn.new(Contact, 
        :name => 'notes'),
    ]
  end

  def insertion_div_id(options)
    params[:insertion_div_id] or scaffold_tbody_id(options)
  end

end
