# This file should contain all the record creation needed to seed the
# database with its default values.  The data can then be loaded with
# the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

# Create the anonymous user
u = User.new(login: 'anonymous',
             email: 'anonymous@invalid',
             password: 'password',
             password_confirmation: 'password')
u.updated_by = 0
u.created_by = 0
u.can_login = false
u.id = 0
u.save
