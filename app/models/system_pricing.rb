class SystemPricing < ActiveRecord::Base
  has_and_belongs_to_many :pricing_values
  belongs_to :system
  belongs_to :spec_sheet
  belongs_to :pricing_type
end
