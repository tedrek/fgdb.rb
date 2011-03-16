// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

cashierable_enabled = true;

function selection_toggle(id) {
  var e = $('Assignment' + "_" + id);
  if(e.className != 'selected') {
    e.old_class = e.className;
    e.className = 'selected';
  } else {
    e.className = e.old_class;
  }
}

function all_selected() {
  var a = document.getElementsByClassName("selected");
  var r = [];
  for(var i = 0; i < a.length; i++) {
    var x = a[i];
    var s = x.id.split("_")[1];
    r.push(s);
  }
  return r.join(",");
}

function do_multi_edit() {
  ids = all_selected();
  if(ids.length == 0) {
    alert("Select some assignments to mass edit using the 's' links and try again");
    return;
  }
  window.location.href = "/assignments/edit/" + ids;
}

function show_message(msg) {
  popup1 = new Popup();
  popup1.content = msg;
  popup1.style = {'border':'3px solid black','backgroundColor':'white'};
  popup1.show();
  document.onkeydown = function(e){
    var keycode;
    if (e == null) {
      keycode = event.keyCode;
    } else {
      keycode = e.which;
    }
    if(keycode == 27){
      popup1.hide();
      document.onkeydown = null;
    }
  };
}

var FixedAutocomplete = Class.create(Ajax.Autocompleter, {
  baseInitialize: function($super,element, update, options) {
    $super(element, update, options);
    Event.observe(this.element, "input", this.onInput.bindAsEventListener(this));
  },

   onInput: function(event) {
     if(this.observer) clearTimeout(this.observer);

     this.observer = setTimeout(this.onObserverEvent.bind(this), this.options.frequency*1000);
     if(this.options.afterInput) {
       this.options.afterInput();
     }
   },
});

function trigger_volunteer_task_type() {
  $('volunteer_task_program').value = volunteer_task_programs[$('volunteer_task_volunteer_task_type').value];
}

function toggle_the_admin() {
  div = $('hidden_admin');
  klass = 'hidden';
  if(div.hasClassName(klass)) {
    div.removeClassName(klass);
  } else {
    div.addClassName(klass);
  }
}

function update_cashier_code() {
  cashier_id_field = $('cashier_code');
  if(cashier_id_field == null)
    return;
  thing = document.getElementsByClassName('cashierable_form')[0];
  if(cashier_id_field.value.length == 4) {
    if(arguments[0] != null) {
      good_cashier_code(cashier_id_field.value, arguments[0]);
    } else {
      good_cashier_code(cashier_id_field.value);
    }
  } else {
    disable_cashierable();
  }
}

function form_to_json(){
  form_id = editable_form_name;
  if($(form_id) == null)
    return "";
  orig = cashierable_enabled;
  if(orig == false) {
    enable_cashierable();
  }
  var hash = Form.serialize(form_id).toQueryParams();
  hash.cashier_code = "...";
  var result = Object.toJSON(hash);
  if(orig == false) {
    disable_cashierable();
  }
  if(orig != cashierable_enabled) {
    alert("BUG, form_to_json");
  }
  return result;
}

function set_contact_name() {
  list = document.getElementsByClassName('contact_search_textbox')[0].value.split(' ');
  if(list.length == 2) {
    $('contact_first_name').value = list[0];
    $('contact_surname').value = list[1];
  }
}

function process_hide(){
  if($('hideable_check').checked) {
    _hide_changes("hidden", "hideable", "show", "hide");
  } else {
    _hide_changes("hideable", "hidden", "hide", "show");
  }
}

function _hide_changes(one, two, three, four){
  document.getElementsByClassName(one)[0].className = two;
//  $('hideable_label').innerHTML = $('hideable_label').innerHTML.replace(three, four);
}

function disable_cashierable(){
  cashierable_enabled = false;
    thing.disable();
  if(document.getElementsByClassName('cancel')[0] != null) {
    document.getElementsByClassName('cancel')[0].disabled = false;
  }
    disable_all_links();
  if(typeof(form_is_editable) == "undefined" || form_is_editable) {
    $('cashier_code').enable();
  }
    $('cashier_code').focus();
}

function disable_always_disabled(){
  var arr = document.getElementsByClassName("always_disabled");
  for (var i = 0; i < arr.length; i++) {
    var thing = arr[i];
    thing.disable();
  }
}

function enable_cashierable(){
  cashierable_enabled = true;
    thing.enable();
    disable_always_disabled();
    enable_all_links();
  if($('covered')) {
    $('covered').value = "nil";
  }
}

function show_contract_notes() {
  if($('donation_contract_id') == null)
    return;
  var mynotes = contracts_notes[parseInt($('donation_contract_id').value)];
  $('contract_notes').innerHTML = mynotes;
  if(mynotes.length > 0){
    $('contract_notes').show();
  } else {
    $('contract_notes').hide();
  }
  contract_selected();
}

function select_visibility(obj_name, method_name, choices, value) {
    for( var i = 0; i < choices.length; i++)
    {var choice = choices[i]; if(choice == 'extend') {}
        else if(choice == value) {$(obj_name + '_' + choice + '_choice').show();}
        else {$(obj_name + '_' + choice + '_choice').hide();} }
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

function set_display_mode(type, mode) {
  $$(type).each(function(elem) {
                  if (mode == 0) {
                    elem.hide();
                  } else {
                    elem.show();
                  }
                });
}

function contact_form_org_toggle() {
  if( $('contact_is_organization').checked ) {
    $$('.organization').each(function(elem) { elem.show(); });
  } else {
    $$('.organization').each(function(elem) { elem.hide(); });
  }
}

function defined(variable)
{
    return (typeof(variable) != 'undefined');
}

function form_has_not_been_edited(form_name) {
  return form_to_json() == initial_form_json;
}

function set_new_val(element, new_val) {
  element.value = new_val;
  element.defaultValue = new_val;
  trigger_change_on(element);
}

function trigger_change_on(element) {
  var event = document.createEvent('HTMLEvents');
  event.initEvent('change',true,true);
  element.dispatchEvent(event);
}

function update_all_gizmo_totals(){
    var myotherarray = document.getElementsByClassName('total_price_div');
    for(var i5=0; i5 < myotherarray.length; i5++) {
        this_child = myotherarray[i5];
        name = this_child.childNodes[3].id.match(/(.*)_total_price/)[1];
        if (name)
          update_gizmo_totals(name);
    }
}

function update_gizmo_totals (id_thing) {
  var multiplier = (discount_schedules[$('sale_discount_schedule_id').value][$(id_thing + '_gizmo_type_id').value]) || 0;
  var amount_b4_discount = (Math.floor($(id_thing + '_unit_price').value*100) * Math.floor($(id_thing + '_gizmo_count').value)) || 0;
  var amount = multiplier * amount_b4_discount;
  if (isNaN(amount))
      amount = 0;
  amount = Math.floor(amount)/100.0;
  var mystring = "$" + amount;
  $(id_thing + '_total_price').value = mystring;
  $(id_thing + '_total_price').defaultValue = mystring;
}

function remove_condition(obj_name, value)
{
  Element.remove(obj_name + "_tbody_for_" + value);
  Element.show($(obj_name + "_" + value + "_option"));
  $(obj_name + '_' + value + '_enabled').value = false;
}

function add_condition(obj_name, value)
{
  if(value != ''){
    var list_of_conditions = eval("list_of_" + obj_name + "_conditions");
    var condition_display_names  = eval("condition_" + obj_name + "_display_names");
    Insertion.Bottom(obj_name + "_table", '<tbody id="' + obj_name + '_tbody_for_' + value + '"><tr><th class="conditions"><span>' + condition_display_names.get(value) + ':</span></td><td>' + list_of_conditions.get(value) + '</td><td><span><input value="-" type="button" id="' + obj_name + '_delete_"' + value + '" onclick="remove_condition(\'' + obj_name + '\', \'' + value + '\')"/></span></td></tr></tbody>');
    Element.hide($(obj_name + '_' + value + '_option'));
    $(obj_name + '_' + value + '_enabled').value = true;
    $(obj_name + '_adder').value = "";
    $(obj_name + '_adder').focus();
  }
}

function disable_all_links() {
  var arr = document.getElementsByClassName("disable_link");
  for (var i = 0; i < arr.length; i++) {
    var thing = arr[i];
    if(thing.status == undefined || thing.status == 0) {
      thing.origOnClick = thing.onclick;
      thing.onclick = function () { return false; };
      thing.status = 1;
    }
  }
}

function enable_all_links() {
  var arr = document.getElementsByClassName("disable_link");
  for (var i = 0; i < arr.length; i++) {
    var thing = arr[i];
    if(thing.status == 1) {
      thing.onclick = thing.origOnClick;
      thing.origOnClick = "";
      thing.status = 0
    }
  }
}

function toggle_description(evt) {
  show_description++;
  var arr = document.getElementsByClassName('description');
  for (var i = 0; i < arr.length; i++) {
    set_visibility(arr[i], show_description & 1)
  }
  return true;
}
