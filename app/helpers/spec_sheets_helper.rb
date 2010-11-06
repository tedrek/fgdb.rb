module SpecSheetsHelper
  def render_pci_guts()
    my_id = @parser.my_node 
    my_ser = @parser.xml_value_of("serial")
    my_ser = nil if my_ser == "Unknown"
    if @seen.include?(my_id) || (my_ser && @seen_ser.include?(my_ser))
      return ""
    else
      @seen << my_id
      @seen_ser << my_ser if my_ser
    end
    return render :partial => "pci_guts"
  end
end
