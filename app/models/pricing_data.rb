class PricingData < ActiveRecord::Base
  def PricingData.load_from_csv(table_name, csv_data)
    table_name = table_name.downcase.gsub(' ', '_')
    rows = CSV.parse(csv_data)
    row_header = rows.shift
    row_header.shift # should be == table_name ?
    pd = []
    rows.each do |row|
      printme_value = row.shift
      row.each_with_index do |col, num|
        lookup_value = col
        lookup_type = row_header[num]
        pd << PricingData.new(:table_name => table_name, :printme_value => printme_value, :lookup_value => lookup_value, :lookup_type => lookup_type)
      end
    end
    PricingData.destroy_all ['table_name LIKE ?', table_name]
    pd.each{|x| x.save}
  end

  def PricingData.lookup(table_name, printme_value, lookup_type)
    pd = nil
    PricingData.find_all_by_table_name_and_lookup_type(table_name, lookup_type).each do |x|
      if SystemPricing.does_match?(x.printme_value.to_s, printme_value.to_s)
        pd = x.lookup_value
      end
    end
    return pd
  end

  def PricingData.tables
    DB.exec("SELECT DISTINCT table_name FROM pricing_datas;").to_a.map{|x| x.values.first.humanize}
  end
end
