// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

var AjaxScaffold = {
  stripe: function(tableBody) {
    var even = false;
    var tableBody = $(tableBody);
    var tableRows = tableBody.getElementsByTagName("tr");
    var length = tableBody.rows.length;

    for (var i = 0; i < length; i++) {
      var tableRow = tableBody.rows[i];
      //Make sure to skip rows that are create or edit rows or messages
      if (!Element.hasClassName(tableRow, "create")
        && !Element.hasClassName(tableRow, "update")) {

        if (even) {
          Element.addClassName(tableRow, "even");
        } else {
          Element.removeClassName(tableRow, "even");
        }
        even = !even;
      }
    }
  },
  displayMessageIfEmpty: function(tableBody, emptyMessageElement) {
    // Check to see if this was the last element in the list
    if ($(tableBody).rows.length == 0) {
      Element.show($(emptyMessageElement));
    }
  },
  removeSortClasses: function(scaffoldId) {
    $$('#' + scaffoldId + ' td.sorted').each(function(element) {
      Element.removeClassName(element, "sorted");
    });
    $$('#' + scaffoldId + ' th.sorted').each(function(element) {
      Element.removeClassName(element, "sorted");
      Element.removeClassName(element, "asc");
      Element.removeClassName(element, "desc");
    });
  }
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
  var trigElementId = Event.element(event).id;
  if (patterns.length > 0) {
    if (matchValueVsManyPatterns(trigElementId, patterns)) {
      new Ajax.Request('/' + controller + '/update_totals?' + value, {asynchronous:true, evalScripts:true});
    }
  }
}

function updateTotalsForContext( element, value,  event, context) {
  var patts = [];
  var controller = 'transaction';
  if (context == 'donation') {
    patts.push('amount$');
    patts.push('payment_method_id$');
    patts.push('gizmo_count$');
    patts.push('gizmo_type_id$');
  }
  else if (context == 'sale') {
    patts.push('amount$');
    patts.push('payment_method_id$');
    patts.push('unit_price$');
    patts.push('gizmo_count$');
    patts.push('discount_schedule_id$');
  }
  updateTotalsIfMatch( element, value, event, controller, patts);
}

function updateTotals(formId) {
  var value = Form.serialize(formId);
  new Ajax.Request('/donations/update_totals?' + value, {asynchronous:true, evalScripts:true});
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

function task_form_has_not_been_edited() {
  return(
    ($('volunteer_task_duration').value == '') &&
    (
      (! $('volunteer_task_contact_id')) ||
      ($('volunteer_task_contact_id').value == '')
    )
  );
}