module ApplicationHelper

  def datebocks_field(object_name, method)
    calendar_ref = object_name + '_' + method
    <<-EOL
      <div id="dateBocks">
        <ul>
          <li>#{text_field object_name, method, { :onChange => "magicDate('#{calendar_ref}');", :onKeyPress => "magicDateOnlyOnSubmit('#{calendar_ref}', event); return dateBocksKeyListener(event);", :onClick => "this.select();"} }</li>
          <li>#{engine_image('icon-calendar.gif', :engine => 'datebocks', :alt => 'Calendar', :id => calendar_ref + 'Button', :style => 'cursor: pointer;' ) }</li>
          <li>#{engine_image('icon-help.gif', :engine => 'datebocks', :alt => 'Help', :id => calendar_ref + 'Help' ) }</li>
        </ul>
        <div id="dateBocksMessage"><div id="#{calendar_ref}Msg"></div></div>
        <script type="text/javascript">
          document.getElementById('#{calendar_ref}Msg').innerHTML = calendarFormatString;
          
          Calendar.setup({
      	   inputField     :    "#{calendar_ref}",        // id of the input field
      	   ifFormat       :    calendarIfFormat,         // format of the input field
      	   button         :    "#{calendar_ref}Button",  // trigger for the calendar (button ID)
      	   help           :    "#{calendar_ref}Help",    // trigger for the help menu
      	   align          :    "Br",                     // alignment (defaults to "Bl")
      	   singleClick    :    true
      	  });
          //document.getElementById('#{calendar_ref}').onkeydown = dateBocksKeyListener;
          
        </script>
      </div>
    EOL
  end

end