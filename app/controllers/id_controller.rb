class IdController < ApplicationController
  layout nil

  def index
  end

  def lookup
    @contact = Contact.find(:first,
                            :conditions =>
                            ['upper(first_name)=? AND upper(surname)=?',
                             params[:first_name].upcase,
                             params[:surname].upcase])
  end
end
