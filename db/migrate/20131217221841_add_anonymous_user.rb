class AddAnonymousUser < ActiveRecord::Migration
  def self.up
    # Create the anonymous user
    u = User.new(login: 'anonymous',
                 email: 'anonymous@invalid',
                 password: 'password',
                 password_confirmation: 'password')
    u.updated_by = 0
    u.created_by = 0
    u.can_login = false
    u.id = 0
    u.save!
  end

  def self.down
    User.find(id: 0).destroy
  end
end
