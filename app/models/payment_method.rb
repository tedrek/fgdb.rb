

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

  def PaymentMethod.descriptions
    @@descriptions ||= {}
    if @@descriptions.empty?
      find_all.each {|p_m|
        @@descriptions[p_m.id] = p_m.description
      }
    end
    @@descriptions
  end

end
