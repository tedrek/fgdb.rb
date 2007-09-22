# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def contact_search_box
    render :partial => 'contacts/lookup'
  end

  def header_totals_id(options)
    "#{options[:scaffold_id]}_header_totals"
  end

  def anonymize_button_id(options)
    "#{options[:scaffold_id]}_anonymize"
  end

  def content_id(options)
    'content'
  end

  def scaffold_form_tbody_id(options)
    "#{options[:scaffold_id]}_form_tbody"
  end

  # due to prototype suckness, 'extend' may not be used as a choice name.
  def select_visibility(obj_name, method_name, choices = {})
    #:TODO: scrub this first
    obj = eval( "@#{obj_name}" )

    js_observe_fuct = 'var choices = new Array("%s");' % choices.keys.map {|k| k.to_s}.join('", "')
    js_observe_fuct += "for( var i = 0; i < choices.length; i++)"
    js_observe_fuct += "{var choice = choices[i]; if(choice == 'extend') {}"
    js_observe_fuct += "else if(choice == value) {$('#{obj_name}_' + choice + '_choice').show();}"
    js_observe_fuct += "else {$('#{obj_name}_' + choice + '_choice').hide();} }"

    # type choice
    display = %Q{ <div class="form-element"> %s %s </div> } %
      [ select( obj_name, method_name, choices.keys.map {|k| k.to_s} ),
        observe_field( "#{obj_name}_#{method_name}",
                       :function => js_observe_fuct,
                       :with => method_name )]

    this_choice = obj.send(method_name)
    choices.each {|choice, content|
      if this_choice.to_s == choice.to_s
        visibility = ''
      else
        visibility = 'style="display:none;"'
      end
      display += %Q{ <div id="%s_%s_choice" class="form-element" %s>%s</div> } % [ obj_name, choice.to_s, visibility, content ]
    }

    return display
  end

  # the object named "@#{obj_name}" must be able to respond to all the
  # fields listed below, or you should provide alternate fieldnames.
  def date_or_date_range_picker(obj_name, fields = {})
    date_types = {}
    obj = eval( "@#{obj_name}" )
    fields = { :date => 'date',
      :start_date => 'start_date', :end_date => 'end_date',
      :month => 'month', :year => 'year',
      :date_type => 'date_type' }.merge(fields)

    # daily
    date_types['daily'] = toolbocks_date_select(obj_name, fields[:date])
    date_types['monthly'] = select_month(obj.send(fields[:month]), :prefix => obj_name) +
      select_year(obj.send(fields[:year]), :prefix => obj_name)
    # arbitrary
    date_types['arbitrary'] = "From: %s To: %s" %
      [ toolbocks_date_select(obj_name, fields[:start_date]),
        toolbocks_date_select(obj_name, fields[:end_date]) ]

    return select_visibility(obj_name, fields[:date_type], date_types)
  end

  def time_or_time_range_picker(obj_name, fields)
    #:TODO: ?
  end
end
