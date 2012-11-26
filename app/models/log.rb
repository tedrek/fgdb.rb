class Log < ActiveRecord::Base
  def string
    a = ["at", self.date.to_s, "record", self.action_past]
    user = cashier = nil
    user = User.find(self.user_id) if self.user_id
    cashier = User.find(self.cashier_id) if self.cashier_id
    user = user.contact ? user.contact.display_name : user.login if user
    cashier = cashier.contact ? cashier.contact.display_name : cashier.login if cashier
    if user
      a << "by"
      a << (cashier || user)
    end
    if user and cashier and user != cashier
      a << "logged in as"
      a << user
    end
    a.join(" ")
  end

  def action_past
    action.match(/e$/) ? action + "d" : action + "ed"
  end
end
