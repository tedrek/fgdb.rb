class PricingData < ActiveRecord::Base
  def PricingData.load_from_csv(printme_pull_from, csv_data)
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
    pd = PricingData.find_by_printme_pull_from_and_printme_value_and_lookup_type(printme_pull_from, printme_value, lookup_type)
    return pd ? pd.lookup_value : nil
  end
end
