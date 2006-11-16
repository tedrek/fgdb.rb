// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

function playwith_fees(o) {
  var params = Form.serialize(o.form);
  new Ajax.Request('/donations/update_fee?' + params,
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

function listDonationElementsPatterns() {
  var list = [];
  list.push('money_tendered$');
  list.push('gizmo_count$');
  list.push('gizmo_type_id$');
  return list;
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
function updateFee( element, value,  event) {
  var trigElementId = Event.element(event).id;
  // value = 'id=' + primaryId + '&' + value;
  // var elemMatchPatterns = listDonationElementsPatterns;
  var patts = listDonationElementsPatterns();
  if (matchValueVsManyPatterns(trigElementId, patts)) {
    new Ajax.Request('/donations/update_fee?' + value, {asynchronous:true, evalScripts:true});
  }
}
function calcFees(formId) {
  // alert ("Firing calcFees("+formId+','+primaryId+')');
  var value = Form.serialize(formId)
  // value = 'id=' + primaryId + '&' + value;
  new Ajax.Request('/donations/update_fee?' + value, {asynchronous:true, evalScripts:true});
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
