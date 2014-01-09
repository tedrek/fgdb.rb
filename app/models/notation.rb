class Notation < ActiveRecord::Base
  belongs_to :contact
  belongs_to :notatable, polymorphic: true

  validates :content, presence: true
  validates :contact, presence: true
  validates :notatable, presence: true
end
