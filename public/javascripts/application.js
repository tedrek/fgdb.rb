// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

/**  START outline of donations fee monitoring code  -----------------
*
*   // method to discover fees asked and paid and alert user
*   // triggered by "onchange" in some form elements
*   function update_totals(some_form_elem) {
*     var tot_req_fee = sum_required_fees(myform)
*     var tot_sug_fee = sum_suggested_fees(myform)
*     var tot_fee = tot_req_fee + tot_sug_fee
*     var tendered_amt = tendered_payment(myform);    //or inline
*     var overunder_amt = tendered_amt - tot_fee
*     var msg_members = [
*       'Required fee', tot_req_fee,
*       'Suggested fee', tot_sug_fee,
*       'Total fee', tot_fee,
*       'Tendered amount', tendered_amt,
*       'Over/Under', overunder_amt,
*     ];
*     var msg_elem = build_msg(msg_members)
*     display_msg(msg_elem)
*     return false
*   } // end update_totals()
*
*   // calculate sum of all detail required fees for donation
*   function sum_required_fees(myform)
*   {
*     var id_patt = 'DonatedGizmo_row_'
*     var arr_detail_divs = find_detail_divs(myform,id_patt)
*     for (var detail_div in arr_detail_divs)
*     {
*       var id_patt2
*       // do we have a required fee?
*       id_patt2 = 'donated_gizmo_gizmo_type_id'
*       var gizmo_type = find_first_select(detail_div,id_patt2)
*       // lookup required fee in local table
*       var type_req_fee = get_req_fee(gizmo_type)
*
*
*       // get quantity and test for positive integer
*       id_patt2 = 'donated_gizmo_quantity'
*       var qty = find_first_input(detail_div,id_patt2)
*       // sanity check on quantity
*       if (qty==null or qty<=0) return 0
*
*       return sum_fee
*     }
*   }
*
*   // find first input element with id matching given pattern
*   function find_first_input(parent,patt)
*   {
*     // iterate through input elements
*     var arr_elems = find_inputs(parent,patt)
*     if (arr_elems[0] == null) {
*       return null
*     else
*       return arr_elems[0]
*     }
*   }
*
*   // find all input elements in parent with id matching given pattern
*   function find_inputs(parent,patt)
*   {
*     var all_inputs = parent.getElementsByTagName('input')
*     var sel_inputs
*     // sanity check
*     if (all_inputs[0] == null) return null
*     // iterate through input elements looking for pattern
*     for (var input in all_inputs)
*     {
*       if (patt.match(all_inputs[input].id)) {
*         sel_inputs.push(all_inputs[input])
*       }
*     }
*       return sel_inputs
*     end
*   }
*
*    END   outline of donations fee monitoring code  -----------------
**/

// analyze a fieldset and return required and suggested fees for
// the quantity and type of donated item within
function calc_fieldset_fees(o)
{
  var inputs = myform.getElementsByTagName('input');
  for(var input in inputs)
  {
    switch(input.id)
    {
    case "donated_gizmo_gizmo_type_id";
      switch(input.value)
      {
        case "3"
      }
    }
  }
  // return reqfee, suggfee;
  return reqfee;
}

// monitor and display tendered, required, suggested fees
function update_totals(e)
{
  // reset totals vars
  var required_total = 0;
  var suggested_total = 0;
  var total_total = 0;
  var overunder_total;

  // determine form that pertains to current element
  var myform = e.form;

  // gather values needed to calculate fees required, suggested fees
  var tendered_str = document.getElementById('donation_money_tendered');
  // alert(typeof tendered_str);
  // alert(tendered_str.id + ': ' + tendered_str.value);
  var tendered = parseFloat(tendered_str.value);

  // calculate sums for required, suggested, total fees
  var divs = myform.getElementsByTagName('div');
  for(var div in divs)
  {
    if(/totals/.test(divs[div].id))
    {
      var spans = divs[div].getElementsByTagName('span');
      for(var span in spans)
      {
        if(/required_amt/.test(spans[span].id))
        {
          var required_fee = parseFloat(spans[span].innerHTML);
          required_fee++;
          required_total += required_fee;
          spans[span].innerHTML = required_fee.toString();
        }
        if(/suggested_amt/.test(spans[span].id))
        {
          var suggested_fee = parseFloat(spans[span].innerHTML);
          suggested_fee++;
          suggested_total += suggested_fee;
          spans[span].innerHTML = suggested_fee.toString();
        }
        if(/total_amt/.test(spans[span].id))
        {
          total_total = required_total + suggested_total;
          spans[span].innerHTML = total_total.toString();
        }
      }
      spans['tendered_amt'].innerHTML = tendered.toString();
      // spans['tendered_amt'].innerHTML = tendered_str;
      overunder_total = tendered - total_total;
      spans['overunder_amt'].innerHTML = overunder_total.toString();
    }
  }

}
