class AddAdoptionCreditBoolean < ActiveRecord::Migration
  def self.up
    add_column :programs, :adoption_credit, :boolean, :null => false, :default => true
    Program.find(:all).each{|x|
      if ["build", "spanish", "intern"].include?(x.name)
        x.adoption_credit = false
        x.save!
      end
    }
  end

  def self.down
    remove_column :programs, :adoption_credit
  end
end
