class AddContributionBlurb < ActiveRecord::Migration
  def self.up
    change_column :defaults, :value, :text
    return unless Default.is_pdx
    Default["contribution_blurb"] = "In addition to the required fee, which helps cover the cost of processing your hardware donation, you may wish to make a tax-deductible voluntary contribution. Your contribution helps support our programs, which include recycling many categories of e-waste, giving away free computers and other equipment to individuals and community organizations and providing job-skills training and other educational opportunities to our volunteers and the public."
  end

  def self.down
  end
end
