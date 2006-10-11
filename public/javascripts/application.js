// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

function contact_searchbox_submit(div_id, field_id) {
  var field_val = $(field_id).value;
  new Ajax.Request('/contacts/do_search/?query=' + field_val + 
      '&searchbox_id=' + div_id,
      {asynchronous:true, evalScripts:true}
    );
}

function playwith_fees(o) {
  var params = Form.serialize(o.form);
  new Ajax.Request('/donations/update_fee?' + params,
    {asynchronous:true, evalScripts:true});
}
