class NewsletterSubscriber < ActiveRecord::Base
  def self.subscribe(address)
    return if is_subscribed?(address)
    Notifier.deliver_newsletter_subscribe(address)
  end

  def self.is_subscribed?(address)
    address = address.strip.downcase
    !! NewsletterSubscriber.find_by_email(address)
  end
end
