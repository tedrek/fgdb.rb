// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

// Called as:
// confirmReplaceElementValue(elem_id, new_elem_value, confirm_message)
function confirmReplaceElementValue(id, val, msg){
  var truth_value = confirm(msg)
  if (truth_value){
    // alert("updating element:" + id + " with value:" + val)
    $(id).value = val
  }
  return truth_value
}

// Called as:
// calculateOffsetLeft(_inputField)
// was ob
function calculateOffsetLeft(r){
  return absolute_offset(r,"offsetLeft")
}

// Called as:
// calculateOffsetTop(_inputField)
// Was Qb...
function calculateOffsetTop(r){
  return absolute_offset(r,"offsetTop")
}

function absolute_offset(r,attr){
  var tot=0;
  while(r){
    tot+=r[attr];
    r=r.offsetParent
  }
  return tot
}

function contactKeyListener(event) {
  var keyCode = event.keyCode ? event.keyCode : event.which ? event.which : event.charCode;

        if (keyCode == 13 || keyCode == 10) {
                return false;
  }
}

function magicContactOnlyOnSubmit(button, event) {
  var keyCode = event.keyCode ? event.keyCode : event.which ? event.which : event.charCode;

  if (keyCode == 13 || keyCode == 10) {
    magicContact(button);
  }
}

function magicContact(button) {
  button = $(button);
  button.click();
}

function setRelativelyAbsolute(elem_id, relative_to_id) {
  rel = $(relative_to_id);
  elem = $(elem_id);
  elem.style.left=calculateOffsetLeft(rel)+"px";
  elem.style.top=calculateOffsetTop(rel)+rel.offsetHeight-1+"px";
}

function alertEvent( element, value,  event) {
  // alert('event element: ' + Event.element(event));
  alert('alertEvent: event id: ' + Event.element(event).id);
}

function matchValueVsManyPatterns(value, patts) {
  var stringValue = value.toString();
  patts = $A(patts);
  var result = false;
  patts.each(function(patt, index) {
    var stringPatt = patt.toString();
    var regex = new RegExp(stringPatt);
    if (stringValue.match(regex)) {
      result = true;
    }
  });
  return result;
}
// request only if trigger element id matches one of given patterns
function updateTotalsIfMatch( element, value,  event, controller, patterns) {
  if((event == null) || (patterns.length > 0 && matchValueVsManyPatterns(Event.element(event).id, patterns))) {
    new Ajax.Request('/' + controller + '/update_totals?' + value, {asynchronous:true, evalScripts:true});
  }
}

function updateTotalsForContext( element, value,  event, context) {
  var patts = [];
  var controller = context + 's';
  if (context == 'sale') {
    patts.push('unit_price$');
    patts.push('gizmo_count$');
  }
  patts.push('amount$');
  patts.push('gizmo_type_id$');
  patts.push('payment_method_id$');
  patts.push('discount_schedule_id$');
  updateTotalsIfMatch( element, value, event, controller, patts);
}

function updateTotals(context, formId) {
  var value = Form.serialize(formId);
  new Ajax.Request('/' + context + 's/update_totals?' + value, {asynchronous:true, evalScripts:true});
}

function contact_form_org_toggle() {
  if( $('contact_is_organization').checked ) {
    var hide_type = '.person';
    var show_type = '.organization';
  } else {
    var hide_type = '.organization';
    var show_type = '.person';
  }
  $$(hide_type).each(function(elem) { elem.hide(); });
  $$('input' + hide_type).each(function(elem) {
    elem.checked = false;
    elem.value = '';
  });
  $$(show_type).each(function(elem) { elem.show(); });
}

function defined(variable)
{
    return (typeof(variable) != 'undefined');
}

function form_has_not_been_edited(form_name) {
    var myarray=$(form_name).getElementsByClassName('form-element');
    for (var i = 0; i < myarray.length; i++){
        children=myarray[i].childNodes;
        for(var i2 = 0; i2 < children.length; i2++){
            child=children[i2];
            if(defined(child.tagName)){
                if((child.tagName == "INPUT" && child.type != "checkbox") || child.tagName == "TEXTAREA") {
                    if(child.value != child.defaultValue) {
                        return false;
                    }
                }
                else if(child.tagName == "INPUT" && child.type == "checkbox")
                {
                    if(child.defaultChecked != child.checked) {
                        return false;
                    }
                }
                else if(child.tagName == "SELECT") {
                    options = child.childNodes;
                    var i4 = 0;
                    for (var i3 = 0; i3 < options.length; i3++)
                    {
                        if(options[i3].tagName=="OPTION") {
                            if(options[i3].defaultSelected){
                                if(i4 != child.selectedIndex) {
                                    return false;
                                }
                            }
                            i4++;
                        }
                    }
                }
            }
        }
    }
    return true;
}

function set_new_val(element, new_val) {
  element.value = new_val;
  trigger_change_on(element);
}

function trigger_change_on(element) {
  var event = document.createEvent('HTMLEvents');
  event.initEvent('change',true,true);
  element.dispatchEvent(event);
}
