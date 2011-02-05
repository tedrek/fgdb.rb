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

