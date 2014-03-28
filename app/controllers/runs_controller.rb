class RunsController < ApplicationController
  layout 'with_sidebar'

  def show
    @run = Run.find(params[:id])
  end
end
