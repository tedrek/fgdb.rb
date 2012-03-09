class CreateNewsletterSubscribers < ActiveRecord::Migration
  def self.up
    create_table :newsletter_subscribers do |t|
      t.string :email

      t.timestamps
    end
  end

  def self.down
    drop_table :newsletter_subscribers
  end
end
