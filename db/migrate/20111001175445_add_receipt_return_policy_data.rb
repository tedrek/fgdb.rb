class AddReceiptReturnPolicyData < ActiveRecord::Migration
  def self.up
    return unless Default.is_pdx
    [
                ['standard', '14 DAY EXCHANGE', 'Unless otherwise specified, items may be returned within 14 days for a store credit. You must provide the original receipt at the time of return, and the items must be returned in the same condition in which they were sold.', 'gizmo'],
                ['as_is', 'AS-IS', 'Items marked "As-Is" cannot be returned for any reason; the additional risk is reflected in the low, low price', 'schwag', 'laptop_parts', 'misc_item_as_is', 'scraptop', 'scraptop_mac'],
                ['lcd', 'LCD MONITORS',  'may be returned for store credit within 30 days of purchase', 'monitor_lcd'],
                ['system', 'SYSTEM WARRANTY', 'Please see attached document for details of hardware warranty and tech support policies. Info may also be found at freegeek.org/thrift-store/warranty', 'laptop', 'laptop_mac','system_crt', 'system_crt_mac','system_lcd', 'system_lcd_mac', 'system', 'system_mac']
               ].each{|x|
      rp = ReturnPolicy.new
      rp.name, rp.description, rp.text = x.shift(3)
      rp.save!
      x.each{|n|
        i = 0
        GizmoType.find_all_by_name(n).each{|g|
          g.return_policy_id = rp.id
          g.save!
          i += 1
        }
        if i == 0
          puts "ERROR: did not find #{n}, skipped."
        end
      }
    }
  end

  def self.down
  end
end
