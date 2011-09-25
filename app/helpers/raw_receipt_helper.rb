module RawReceiptHelper
  def receipt_printer_enabled
    session.keys.include?('raw_receipt_printer')
  end

  def receipt_printer_default
    session['raw_receipt_printer']
  end

  def receipt_printer_set_default(val)
    session['raw_receipt_printer'] = val
  end

  def receipt_trailing_newlines
    7
  end

  def generate_raw_receipt(text_lines, printer = nil)
    printer ||= receipt_printer_default
    text_lines.map{|line| receipt_printer_format_line(line, limit_by_printer_name(printer))}.join("\n") + ("\n"*receipt_trailing_newlines) + printer_cut_character(printer)
  end

  def receipt_printer_html
    if receipt_printer_enabled
      return render(:partial => 'raw_receipt_form')
    else
      button_to "Enable Text Receipt Printing For This Session", {:action => 'enable_raw_printing', :printer_name => ""}
    end
  end

# the first subelement would align left, the
#              rest would align right. they would be joined by spaces for as many as will fit before it
#              finds a breaking places to put a \n if necessary and continue its formatting logic on the
#              next line (still aligning right)
  def receipt_printer_format_line(line, limit)
    line.join(' ')# FIXME: needs line limit implementation, and alignment
  end

  def printer_cut_character(printer_name)
    printer_characters = {}
    printer_characters[printer_name] || "\x1Bi" 
  end

  def limit_by_printer_name(printer_name)
    printer_limits = {}
    printer_limits[printer_name] || 44
  end
end

