// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
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
  var tendered = parseFloat(tendered_str.innerHTML);

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
          required_total = required_total + required_fee;
          spans[span].innerHTML = required_fee.toString();
        }
        if(/suggested_amt/.test(spans[span].id))
        {
          var suggested_fee = parseFloat(spans[span].innerHTML);
          suggested_fee++;
          suggested_total = suggested_total + suggested_fee;
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
