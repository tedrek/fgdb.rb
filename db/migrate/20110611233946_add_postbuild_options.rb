class AddPostbuildOptions < ActiveRecord::Migration
  def self.up
    if Default.is_pdx
      for x in ['laptop build', 'mac build', 'server build', 'advanced testing']
        ContactType.new(:for_who => 'per', :description => x, :name => x.gsub(' ', '_')).save
      end
    end
  end

  def self.down
  end
end
