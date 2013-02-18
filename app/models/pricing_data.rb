class PricingData < ActiveRecord::Base
  def PricingData.load_from_csv(printme_pull_from, csv_data)
    printme_pull_from = printme_pull_from.downcase.gsub(' ', '_')
    rows = CSV.parse(csv_data)
    row_header = rows.shift
    row_header.shift # should be == printme_pull_from ?
    pd = []
    rows.each do |row|
      printme_value = row.shift
      row.each_with_index do |col, num|
        lookup_value = col
        lookup_type = row_header[num]
        pd << PricingData.new(:printme_pull_from => printme_pull_from, :printme_value => printme_value, :lookup_value => lookup_value, :lookup_type => lookup_type)
      end
    end
    PricingData.destroy_all ['printme_pull_from LIKE ?', printme_pull_from]
    pd.each{|x| x.save}
  end

  def PricingData.lookup(printme_pull_from, printme_value, lookup_type)
    pd = nil
    PricingData.find_all_by_printme_pull_from_and_lookup_type(printme_pull_from, lookup_type).each do |x|
      if SystemPricing.does_match?(x.printme_value.to_s, printme_value.to_s)
        pd = x.lookup_value
      end
    end
    return pd
  end

  def PricingData.tables
    DB.exec("SELECT DISTINCT printme_pull_from FROM pricing_datas;").to_a.map{|x| x.values.first.humanize}
  end
end
