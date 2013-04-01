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
    PricingData.delete_table(table_name)
    pd.each{|x| x.save}
  end

  def PricingData.delete_table(table_name)
    PricingData.destroy_all ['table_name LIKE ?', table_name]
  end

  def PricingData.find_match(table_name, printme_value)
    pd = nil
    PricingData.table_values(table_name).each do |x|
      if SystemPricing.does_match?(x.to_s, printme_value.to_s)
        pd = x
      end
    end
    return pd
  end

  def PricingData.lookup(table_name, printme_value, lookup_type)
    pd = PricingData.find_match(table_name, printme_value) if printme_value
    ret = nil
    ret = PricingData.find_by_table_name_and_printme_value_and_lookup_type(table_name, pd, lookup_type) if pd
    ret = ret.lookup_value if ret
    return ret
  end

  def PricingData.tables
    DB.exec("SELECT DISTINCT table_name FROM pricing_datas;").to_a.map{|x| x.values.first}
  end

  def PricingData.table_columns(tbl_name)
    DB.exec(["SELECT DISTINCT lookup_type FROM pricing_datas WHERE table_name LIKE ?;", tbl_name]).to_a.map{|x| x.values.first}
  end

  def PricingData.table_values(tbl_name)
    DB.exec(["SELECT DISTINCT printme_value FROM pricing_datas WHERE table_name LIKE ?;", tbl_name]).to_a.map{|x| x.values.first}
  end
end
