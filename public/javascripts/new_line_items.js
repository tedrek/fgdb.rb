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

  update_hook: function() {
    return;
  },

  add: function (args) {
    args['prefix'] = this.prefix;
    args = this.add_hook(args);
    add_line_item(args, this.make_hidden_hook, this.update_hook, this.edit_hook); // TODO: this should move into the class
  },

  add_hook: function(args) {
    return args;
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

  add_from_form: function() {
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
    var line_id = counters[args['prefix'] + '_line_id'];
    tr.appendChild(make_hidden(args['prefix'], "contact_method_type_id", contact_method_types[contact_method_type_id], contact_method_type_id, line_id));
    usable_node = make_hidden(args['prefix'], "ok", contact_method_usable, contact_method_usable, line_id);
    usable_node.className = "ok";
    tr.appendChild(usable_node);
    description_node = make_hidden(args['prefix'], "value", contact_method_value, contact_method_value, line_id);
    description_node.className = "description";
    tr.appendChild(description_node);
  },
});

