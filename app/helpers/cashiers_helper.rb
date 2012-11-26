#!/usr/bin/ruby

module CashiersHelper
  def cashierable
    klass = params[:controller].classify.constantize
    cash = klass.cashierable
    if cash && klass == Contact && current_user && current_user.contact_id && current_user.contact_id == @contact.id
      return false
    else
      return cash
    end
  end

  def cashiers_field(force = false, pass_in = nil)
    pass_in = pass_in.nil? ? "null" : "'#{pass_in}'"
    "<label for=\"cashier_code\">PIN:</label><input name=\"cashier_code\" type=\"password\" id=\"cashier_code\" onKeyUp=\"update_cashier_code(#{pass_in})\" autocomplete=\"off\"/>#{loading_indicator_tag("cashier_loading")}" if cashierable or force
  end

  def cashiers_javascript(force = false, pass_in = nil)
    pass_in = pass_in.nil? ? "null" : "'#{pass_in}'"
    javascript_tag "update_cashier_code(#{pass_in});" if cashierable or force
  end
end
