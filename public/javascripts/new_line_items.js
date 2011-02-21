// redesign

// the backends are mixins, then there's a common middle class which
// includes the default backend, and each frontend subclasses the common
// middle class and can include a mixin if it wants to

// mixins for functions common between frontends can be created and
// included the same way.

var OneATimeLineItemBackend = {

};

// *backend*
// var AllAtOnceLineItemBackend = {
//
// };

// includes the default backend, it will be overriden if one is
// passed. but this makes it optional to pass since most use the default.

var LineItem = Class.create(OneATimeLineItemBackend, {
  /*
  edit_hook: function(id) {

  },
*/
  edit_hook: false,
  copyable: false,
  linelist: null,

  update_hook: function() {
    return;
  },

  add: function (args) {
    args = this.add_hook(args);
    this.add_line_item(args);
  },

  edit: function (line_id) {
    this.edit_hook(line_id);
    this.editing_id = this.getValueBySelector($(line_id), ".id"); // TODO: need to display the editing to user somehow, and allow them to clear it. (with an x next to the editing boxes)
    Element.remove(line_id);
    this.update_hook();
  },

  copy: function (line_id) {
    this.edit_hook(line_id);
    this.update_hook();
  },

  make_hidden: function (name, display_value, value){
    var line_id = this.counter;
    var prefix = this.prefix;
    hidden = document.createElement("input");
    hidden.name = prefix + '[-' + line_id + '][' + name + ']';
    hidden.value = value;
    hidden.type = 'hidden';
    td = document.createElement("td");
    td.className = name;
    td.appendChild(hidden);
    td.appendChild(document.createTextNode(display_value));
    return td;
  },

  initialize: function() {
    this.counter = 0;
    this.editing_id = undefined;
  },

  remove: function(line_id){
    Element.remove(line_id);
    this.update_hook();
  },

  add_line_item: function (args){
    var id = this.prefix + '_' + this.counter + '_line';
    tr = document.createElement("tr");
    tr.className = "line";
    tr.id = id;
    this.make_hidden_hook(args, tr);
    td = document.createElement("td");
    a = document.createElement("a");
    var self = this;
    a.onclick = function () {
      self.edit(id);
    };
    if(this.edit_hook) {
      a.appendChild(document.createTextNode('e'));
      a.className = 'disable_link';
      td.appendChild(a);
    }
    a = document.createElement("a");
    a.onclick = function () {
      self.copy(id);
    };
    if(this.copyable) {
      td.appendChild(document.createTextNode(' '));
      a.appendChild(document.createTextNode('c'));
      a.className = 'disable_link';
      td.appendChild(a);
    }
    td.appendChild(document.createTextNode(' '));
    a = document.createElement("a");
    a.onclick = function () {
      self.remove(id);
    };
    a.appendChild(document.createTextNode('x'));
    a.className = 'disable_link';
    td.appendChild(a);
    if(!args['uneditable']) {
      tr.appendChild(td);
    }
    if(!defined(args['id'])) {
      args['id'] = this.editing_id;
    }
    tr.appendChild(this.make_hidden("id", "", args['id']));
    $(this.prefix + '_lines').lastChild.insertBefore(tr, $(this.prefix + '_form'));
    this.counter++;
    this.update_hook();
    this.editing_id = undefined;
  },

  add_hook: function(args) {
    return args;
  },

  add_many: function(many) {
    var self = this;
    many.each(function(x) {
      self.add(x);
    });
    return;
  },

  handle_event: function(event) {
    if(this.is_tab(event)) {
      if(event.target.onchange) {
        event.target.onchange();
      }
      if(this.is_last(event)) {
        return this.add_from_form_hook();
      }
    }
  },

  is_tab: function(event) {
    return (event.keyCode==9 && !event.shiftKey);
  },

  is_last: function(event) {
    var names = this.linelist;

    var last = null;
    for(var i in names) {
      if(this.is_enabled_visable_there_field_thing(names[i])) {
        last = names[i];
      }
    }

    return last == event.target.id;
  },

  getValueBySelector: function (thing, selector) {
    return thing.getElementsBySelector(selector).first().firstChild.value;
  },

  is_enabled_visable_there_field_thing: function(name) {
    var el = $(name);
    if(!el) {
      return false;
    }
    if(el == null) {
      return false;
    }
    if(el.disabled) {
      return false;
    }
    if(!el.visible) {
      return false;
    }
    return true;
  },
});

// *backend*
// var LineItemFrontendExample = Class.create(LineItem, AllAtOnceLineItemBackend, {
//
// });
//
// ALWAYS: classes, then mixins, then hash of methods


function eexists(eid) {
  return ($(eid) != null);
}

var ContactMethodFrontend = Class.create(LineItem, {
  prefix: 'contact_methods',
  linelist: ['contact_method_value'],

  edit_hook: function(id) {
    thing = $(id);
    $('is_usable').checked = eval(getValueBySelector(thing, ".ok"));
    $('contact_method_type_id').value = getValueBySelector(thing, ".contact_method_type_id");
    $('contact_method_value').value = getValueBySelector(thing, ".description");
    $('contact_method_type_id').focus();
  },

  add_from_form_hook: function() {
    if($('contact_method_value').value == '' || $('contact_method_type_id').selectedIndex == 0) {
      return true;
    }

    args = new Object();
    args['contact_method_type_id'] = $('contact_method_type_id').value;
    args['contact_method_usable'] = $('is_usable').checked;
    args['contact_method_value'] = $('contact_method_value').value;

    this.add(args);
    $('contact_method_type_id').selectedIndex = 0; //should be default, but it's yucky
    $('contact_method_value').value = $('contact_method_value').defaultValue;
    $('is_usable').checked = false;
    $('contact_method_type_id').focus();
    return false;
  },

  make_hidden_hook: function (args, tr) {
    var contact_method_value = args['contact_method_value'];
    var contact_method_type_id = args['contact_method_type_id'];
    var contact_method_usable = args['contact_method_usable'];
    tr.appendChild(this.make_hidden("contact_method_type_id", contact_method_types[contact_method_type_id], contact_method_type_id));
    usable_node = this.make_hidden("ok", contact_method_usable, contact_method_usable);
    usable_node.className = "ok";
    tr.appendChild(usable_node);
    description_node = this.make_hidden("value", contact_method_value, contact_method_value);
    description_node.className = "description";
    tr.appendChild(description_node);
  },
});

  function three_to_one(hour, min, ampm) {
        if(hour != "12" && ampm == "PM") {
          hour = "" + (parseInt(hour) + 12);
             } else if(hour == "12" && ampm == "AM") {
                  hour = "0";
                 }
        return hour + ":" + min;
      }

  function one_to_three(one) {
        arr = one.split(":");
        hour = arr[0];
        min = arr[1];
        ampm = "AM";
        if(hour >= 12) {
              if(hour != 12) {
                    hour -= 12;
                  }
              ampm = "PM";
            } else if (hour == 0) {
                  hour = 12;
                }
        hour = "" + hour;
        return [hour, min, ampm];
      }

function three_to_form(a) {
    if(a[0].length == 1) {
      a[0] = "0" + a[0];
    }
    if(a[2] == "AM") {
      a[2] = "0";
    }
    if(a[2] == "PM") {
      a[2] = "1";
    }
  return a;
}

function three_to_display(arr) {
  return arr[0] + ":" + arr[1] + " " + arr[2];
}

function form_ampm(ampm) {
    if(ampm == "0") {
      ampm = "AM";
    } else if (ampm == "1") {
      ampm = "PM";
    }
  return ampm;
}

var VolunteerShiftFrontend = Class.create(LineItem, {
  prefix: 'volunteer_shifts',
  linelist: ['volunteer_task_type_id', 'class_credit', 'program_id', 'description', 'roster_id', 'slot_number', 'slot_count', 'date_start_hour', 'date_start_minute', 'date_start_ampm', 'date_end_hour', 'date_end_minute', 'date_end_ampm'],

  edit_hook: function(id) {
    var thing = $(id);
    $('volunteer_task_type_id').value = this.getValueBySelector(thing, ".volunteer_task_type_id");
    if(eexists('slot_number')) {
      $('slot_number').value = this.getValueBySelector(thing, ".slot_number");
    } else {
      $('slot_count').value = this.getValueBySelector(thing, ".slot_count");
    }
    $('roster_id').value = this.getValueBySelector(thing, ".roster_id");
    $('program_id').value = this.getValueBySelector(thing, ".program_id");
    $('description').value = this.getValueBySelector(thing, ".description");
    $('class_credit').checked = eval(this.getValueBySelector(thing, ".class_credit"));
    var a = three_to_form(one_to_three(this.getValueBySelector(thing, ".my_start_time")));
    $('date_start_hour').value = a[0];
    $('date_start_minute').value = a[1];
    $('date_start_ampm').value = a[2];
    a = three_to_form(one_to_three(this.getValueBySelector(thing, ".my_end_time")));
    $('date_end_hour').value = a[0];
    $('date_end_minute').value = a[1];
    $('date_end_ampm').value = a[2];
    $('volunteer_task_type_id').focus();
  },

  add_from_form_hook: function() {
    if((eexists('slot_number') && $('slot_number').value == '')) {
      return true;
    }

    args = new Object();
    if(eexists('slot_number')) {
      args['slot_number'] = $('slot_number').value;
    } else {
      args['slot_count'] = $('slot_count').value;
    }
    args['class_credit'] = $('class_credit').checked;
    args['roster_id'] = $('roster_id').value;
    args['program_id'] = $('program_id').value;
    args['description'] = $('description').value;
    args['volunteer_task_type_id'] = $('volunteer_task_type_id').value;
    var hour = $('date_start_hour').value;
    var minute = $('date_start_minute').value;
    var ampm = form_ampm($('date_start_ampm').value);
    args['my_start_time'] = three_to_one(hour, minute, ampm);
    hour = $('date_end_hour').value;
    minute = $('date_end_minute').value;
    ampm = form_ampm($('date_end_ampm').value);
    args['my_end_time'] = three_to_one(hour, minute, ampm);

    this.add(args);
    $('volunteer_task_type_id').selectedIndex = 0; //should be default, but it's yucky
    $('date_end_hour').selectedIndex = 0;
    $('date_end_minute').selectedIndex = 0;
    $('date_end_ampm').selectedIndex = 0;
    $('date_start_hour').selectedIndex = 0;
    $('date_start_minute').selectedIndex = 0;
    $('date_start_ampm').selectedIndex = 0;
    $('roster_id').selectedIndex = 0;
    $('program_id').selectedIndex = 0;
    $('description').value = $('description').defaultValue;
    $('class_credit').checked = false;
    if(eexists('slot_number')) {
      $('slot_number').value = $('slot_number').defaultValue;
    } else {
      $('slot_count').value = $('slot_count').defaultValue;
    }
    return false;
  },

  copyable: true,

  make_hidden_hook: function (args, tr) {
    var volunteer_task_type_id = args['volunteer_task_type_id'];
    var start_time = args['my_start_time'];
    var end_time = args['my_end_time'];
    var roster_id = args['roster_id'];
    var program_id = args['program_id'];
    var description = args['description'];
    var class_credit = args['class_credit'];

    tr.appendChild(this.make_hidden("volunteer_task_type_id", volunteer_task_types[volunteer_task_type_id], volunteer_task_type_id));
    tr.appendChild(this.make_hidden("class_credit", to_yesno(class_credit), class_credit));
    tr.appendChild(this.make_hidden("program_id", vol_progs[program_id], program_id));
    tr.appendChild(this.make_hidden("description", description, description));
    tr.appendChild(this.make_hidden("roster_id", rosters[roster_id], roster_id));
    if(eexists('slot_number')) {
      var slot_number = args['slot_number'];
      tr.appendChild(this.make_hidden("slot_number", slot_number, slot_number));
    } else {
      var slot_count = args['slot_count'];
      tr.appendChild(this.make_hidden("slot_count", slot_count, slot_count));
    }
    tr.appendChild(this.make_hidden("my_start_time", three_to_display(one_to_three(start_time)), start_time ));
    tr.appendChild(this.make_hidden("my_end_time", three_to_display(one_to_three(end_time)), end_time ));
  },

});
function to_yesno(truefalse) {
  return truefalse ? "yes" : "no";
}
var VolunteerResourceFrontend = Class.create(LineItem, {
  prefix: 'resources_volunteer_events',
  linelist: ['resource_id', 'roster_id2', 'date_start_hour2', 'date_start_minute2', 'date_start_ampm2', 'date_end_hour2', 'date_end_minute2', 'date_end_ampm2'],

  edit_hook: function(id) {
    var thing = $(id);
    $('roster_id2').value = this.getValueBySelector(thing, ".roster_id");
    $('resource_id').value = this.getValueBySelector(thing, ".resource_id");
    var a = three_to_form(one_to_three(this.getValueBySelector(thing, ".my_start_time")));
    $('date_start_hour2').value = a[0];
    $('date_start_minute2').value = a[1];
    $('date_start_ampm2').value = a[2];
    a = three_to_form(one_to_three(this.getValueBySelector(thing, ".my_end_time")));
    $('date_end_hour2').value = a[0];
    $('date_end_minute2').value = a[1];
    $('date_end_ampm2').value = a[2];
    $('resource_id').focus();
  },

  add_from_form_hook: function() {
    if($('resource_id').selectedIndex == 0 || $('roster_id2').selectedIndex == 0) {
      return true;
    }

    args = new Object();
    args['resource_id'] = $('resource_id').value;
    args['roster_id'] = $('roster_id2').value;
    var hour = $('date_start_hour2').value;
    var minute = $('date_start_minute2').value;
    var ampm = form_ampm($('date_start_ampm2').value);
    args['my_start_time'] = three_to_one(hour, minute, ampm);
    hour = $('date_end_hour2').value;
    minute = $('date_end_minute2').value;
    ampm = form_ampm($('date_end_ampm2').value);
    args['my_end_time'] = three_to_one(hour, minute, ampm);

    this.add(args);
    $('date_end_hour2').selectedIndex = 0;
    $('date_end_minute2').selectedIndex = 0;
    $('date_end_ampm2').selectedIndex = 0;
    $('date_start_hour2').selectedIndex = 0;
    $('date_start_minute2').selectedIndex = 0;
    $('date_start_ampm2').selectedIndex = 0;
    $('roster_id2').selectedIndex = 0;
    $('resource_id').selectedIndex = 0;
    return false;
  },

  copyable: true,

  make_hidden_hook: function (args, tr) {
    var start_time = args['my_start_time'];
    var end_time = args['my_end_time'];
    var roster_id = args['roster_id'];
    var resource_id = args['resource_id'];

    tr.appendChild(this.make_hidden("resource_id", vol_resources[resource_id], resource_id));
    tr.appendChild(this.make_hidden("roster_id", rosters[roster_id], roster_id));

    tr.appendChild(this.make_hidden("my_start_time", three_to_display(one_to_three(start_time)), start_time ));
    tr.appendChild(this.make_hidden("my_end_time", three_to_display(one_to_three(end_time)), end_time ));
  },

});
