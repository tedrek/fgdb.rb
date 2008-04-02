class PaymentMethod < ActiveRecord::Base


  def to_s
    description
  end

  def PaymentMethod.cash
    @@cash ||= find( :first, :conditions => ['description = ?', 'cash'] )
  end

  def PaymentMethod.check
    @@check ||= find( :first, :conditions => ['description = ?', 'check'] )
  end

  def PaymentMethod.invoice
    @@invoice ||= find( :first, :conditions => ['description = ?', 'invoice'] )
  end

  def PaymentMethod.coupon
    @@coupon ||= find(:first, :conditions => ['description = ?', 'coupon'])
  end

  def PaymentMethod.credit
    @@credit ||= find(:first, :conditions => ['description = ?', 'credit'])
  end

  def PaymentMethod.is_till_method?(method)
    return [cash, check].map{|x|x.id}.include?(method.id)
  end

  def PaymentMethod.is_money_method?(method)
    return [cash, check, credit].map{|x|x.id}.include?(method.id)
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
