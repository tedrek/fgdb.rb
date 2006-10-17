// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

function playwith_fees(o) {
  var params = Form.serialize(o.form);
  new Ajax.Request('/donations/update_fee?' + params,
    {asynchronous:true, evalScripts:true});
}
