class NotationsController < ApplicationController
  layout nil

  def create
    @notation = Notation.new(contact: User.current_user.contact,
                             content: params[:content],
                             notatable_type: params[:notatable_type],
                             notatable_id: params[:notatable_id])
    if @notation.save
      render 'notation'
    else
      render 'errors'
    end
  end
end
