class AddNoreplyEmail < ActiveRecord::Migration
  def self.up
    if Default.is_pdx
      Default['noreply_address'] = 'noreply@freegeek.org'
    end
  end

  def self.down
  end
end
