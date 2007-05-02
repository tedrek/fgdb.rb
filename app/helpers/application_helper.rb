# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  include DatebocksEngine

  def header_totals_id(options)
    "#{options[:scaffold_id]}_header_totals"
  end

  def anonymize_button_id(options)
    "#{options[:scaffold_id]}_anonymize"
  end

  def scaffold_form_tbody_id(options)
    "#{options[:scaffold_id]}_form_tbody"
  end

  def checkbox_visibility(obj_name, method_name, choices = {})
    #:TODO: scrub this first
    obj = eval( "@#{obj_name}" )
    this_choice = obj.send(method_name).to_s
    js_observe_fuct = visibility_js_fuct(obj_name, choices.keys.map {|k| k.to_s}.join('", "'), false)
    #method_name += '[]' unless /\[\]$/.match?(method_name)

    display = %Q{}
    choices.each do |choice,options|
      choice = choice.to_s
      select_js = "$('%s_%s_%s').click()" % [obj_name, method_name, choice]
      checkbox = %Q{<input type="checkbox" id="%s_%s_%s" name="%s[%s][]" value="%s" %s />} % 
        [obj_name, method_name, choice,
         obj_name, method_name, choice,
         choice == this_choice ? 'CHECKED' : '']
      display += %Q{<div class="checkbox-visibility-choice">%s <span onclick="%s">%s</span>} %
        [checkbox, select_js, options[:label] || Inflector.titleize(choice)]
      display += observe_field( "#{obj_name}_#{method_name}_#{choice}",
                                :function => js_observe_fuct,
                                :with => method_name )
      display += hidden_content(obj_name, choice, this_choice, options[:text])
      display += %Q{</div>}
    end

    return display
  end

  def radio_visibility(obj_name, method_name, choices = {})
    #:TODO: scrub this first
    obj = eval( "@#{obj_name}" )
    this_choice = obj.send(method_name).to_s
    js_observe_fuct = visibility_js_fuct(obj_name, choices.keys.map {|k| k.to_s}.join('", "'))
    display = ''

    choices.each do |choice,options|
      choice = choice.to_s
      select_js = "$('%s_%s_%s').click()" % [obj_name, method_name, choice]
      display += %Q{<p class="radio-visibility-choice">%s <span onclick="%s">%s</span>} %
        [radio_button(obj_name, method_name, choice),
         select_js, options[:label] || Inflector.titleize(choice)]
      display += observe_field( "#{obj_name}_#{method_name}_#{choice}",
                                :function => js_observe_fuct,
                                :with => method_name )
      display += hidden_content(obj_name, choice, this_choice, options[:text])
      display += %Q{</p>}
    end
    return display
  end

  def select_visibility(obj_name, method_name, choices = {})
    #:TODO: scrub this first
    obj = eval( "@#{obj_name}" )

    js_observe_fuct = visibility_js_fuct(obj_name, choices.keys.map {|k| k.to_s}.join('", "'))

    # type choice
    display = %Q{ <div class="form-element"> %s %s </div> } %
      [ select( obj_name, method_name, choices.keys.map {|k| k.to_s} ),
        observe_field( "#{obj_name}_#{method_name}",
                       :function => js_observe_fuct,
                       :with => method_name )]

    this_choice = obj.send(method_name).to_s
    choices.each {|choice, content|
      display += hidden_content(obj_name, choice.to_s, this_choice, content)
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
    date_types['daily'] = datebocks_field(obj_name, fields[:date])
    date_types['monthly'] = select_month(obj.send(fields[:month]), :prefix => obj_name) +
      select_year(obj.send(fields[:year]), :prefix => obj_name)
    # arbitrary
    date_types['arbitrary'] = "From: %s To: %s" %
      [ datebocks_field(obj_name, fields[:start_date]),
        datebocks_field(obj_name, fields[:end_date]) ]

    return select_visibility(obj_name, fields[:date_type], date_types)
  end

  def hidden_content(obj_name, choice, this_choice, text)
    if this_choice == choice
      visibility = ''
    else
      visibility = 'style="display:none;"'
    end
    return %Q{<div id="%s_%s_choice" %s>%s</div>} % [ obj_name, choice,
                                                      visibility, text ]
  end


  def visibility_js_fuct(obj_name, names, exclusive = true)
    js_observe_fuct = 'var choices = new Array("%s");' % names
    js_observe_fuct += "for( var i = 0; i < choices.length; i++)"
    #:MC: prototype.js namespace clobber if we use 'extend'
    js_observe_fuct += "{var choice = choices[i]; if(choice == 'extend') {}"
    js_observe_fuct += "else if(choice == value) {$('#{obj_name}_' + choice + '_choice').show();}"
    js_observe_fuct += "else {$('#{obj_name}_' + choice + '_choice').hide();}" if exclusive
    js_observe_fuct += "}"
    return js_observe_fuct
  end

end
