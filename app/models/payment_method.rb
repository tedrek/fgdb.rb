class PaymentMethod < ActiveRecord::Base
  def to_s
    description
  end

  def PaymentMethod.cash
    @@cash ||= find_by_name('cash')
  end

  def PaymentMethod.check
    @@check ||= find_by_name('check')
  end

  def PaymentMethod.invoice
    @@invoice ||= find_by_name('invoice')
  end

  def PaymentMethod.coupon
    @@coupon ||= find_by_name('coupon')
  end

  def PaymentMethod.credit
    @@credit ||= find_by_name('credit')
  end

  def PaymentMethod.is_till_method?(id)
    return [cash, check].map{|x|x.id}.include?(id)
  end

  def PaymentMethod.is_money_method?(id)
    return [cash, check, credit].map{|x|x.id}.include?(id)
  end

  def PaymentMethod.descriptions
    @@descriptions ||= {}
    if @@descriptions.empty?
      find(:all).each {|p_m|
        @@descriptions[p_m.id] = p_m.description
      }
    end
    @@descriptions
  end
end
