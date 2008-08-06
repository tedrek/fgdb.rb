class ConsolidateCashPayments < ActiveRecord::Migration
  def self.fix_up_payments(tx)
    total = tx.payments.
               select{|x|x.payment_method.description == "cash"}.
               inject(0){|x,y|x+y.amount_cents}
    tx.payments.reject!{|x|x.payment_method.description == "cash" && x.destroy}
    tx.payments << Payment.new({:amount_cents => total,
                                :payment_method => PaymentMethod.cash})
    tx.save!
  end
  def self.up
    Sale.find_by_sql("SELECT t.* 
                      FROM sales AS t 
                      WHERE (SELECT COUNT(*) 
                             FROM payments AS p 
                                  JOIN payment_methods AS pm ON p.payment_method_id=pm.id
                             WHERE sale_id=t.id
                                   AND pm.description='cash'
                             ) > 1").each{|x|
      fix_up_payments(x)
    }

    Donation.find_by_sql("SELECT t.* 
                          FROM donations AS t 
                          WHERE (SELECT COUNT(*) 
                                 FROM payments AS p 
                                      JOIN payment_methods AS pm ON p.payment_method_id=pm.id
                                 WHERE donation_id=t.id
                                       AND pm.description='cash'
                                 ) > 1").each{|x|
      fix_up_payments(x)
    }
  end

  def self.down
  end
end
