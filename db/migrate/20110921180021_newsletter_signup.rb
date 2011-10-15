class NewsletterSignup < ActiveRecord::Migration
  def self.up
    ct = ContactType.new
    ct.for_who = 'any'
    ct.description = ct.name = 'enewsletter'
    ct.save!
    ct = ContactType.new
    ct.for_who = 'any'
    ct.description = ct.name = 'vnewsletter'
    ct.save!
  end

  def self.down
  end
end
