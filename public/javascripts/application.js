// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

function playwith_fees(o) {
  var params = Form.serialize(o.form);
  new Ajax.Request('/donations/update_totals?' + params,
    {asynchronous:true, evalScripts:true});
}

function playwith_amounts(o) {
  var params = Form.serialize(o.form);
  new Ajax.Request('/sale_txns/update_sale_txn_amounts?' + params,
    {asynchronous:true, evalScripts:true});
}

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
  return Ya(r,"offsetLeft")
}

// Called as:
// calculateOffsetTop(_inputField)
// Was Qb...
function calculateOffsetTop(r){
  return Ya(r,"offsetTop")
}

function Ya(r,attr){
  var kb=0;
  while(r){
    kb+=r[attr]; 
    r=r.offsetParent
  }
  return kb
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
  var pattArray = $A(patts);
  var result = false;
  pattArray.each(function(patt, index) {
    var stringPatt = patt.toString();
    var regex = new RegExp(stringPatt);
    if (stringValue.match(regex)) {
      /* alert('value ['+value+'] matched pattern ['+patt+']'); */
      result = true;
    }
  });
  return result;
}
// request only if trigger element id matches one of given patterns
function updateTotalsIfMatch( element, value,  event, controller, patterns) {
  var trigElementId = Event.element(event).id;
  if (patterns.length > 0) {
    if (matchValueVsManyPatterns(trigElementId, patterns)) {
      // alert('MATCH occurred!(updateTotalsIfMatch) (' +element.id+ ', ' +value+ ', ' +Event.element(event).id+ ', ' +controller+ ', ' +patterns+ ')');
      new Ajax.Request('/' + controller + '/update_totals?' + value, {asynchronous:true, evalScripts:true});
    }
  }
}
function updateTotalsForContext( element, value,  event, context) {
  var patts = [];
  var controller = '';
  if (context == 'donation') {
    controller = 'donations';
    patts.push('money_tendered$');
    patts.push('gizmo_count$');
    patts.push('gizmo_type_id$');
  } 
  else if (context == 'sale') {
    controller = 'sale_txns';
    patts.push('unit_price$');
    patts.push('gizmo_count$');
    patts.push('gizmo_type_id$');
    patts.push('discount_schedule_id$');
  }
  updateTotalsIfMatch( element, value, event, controller, patts);
}
function updateTotals(formId) {
  var value = Form.serialize(formId)
  new Ajax.Request('/donations/update_totals?' + value, {asynchronous:true, evalScripts:true});
}

var ActivityResponder = {  
    onCreate: function(request) {  
        $('global-indicator-small').show();  
    },  
    onComplete: function(request) {  
        $('global-indicator-small').hide();  
    }  
}

Ajax.Responders.register(ActivityResponder);
