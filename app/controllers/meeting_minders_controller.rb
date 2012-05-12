class MeetingMindersController < ApplicationController
  layout :with_sidebar

  def index
    @meeting_minders = MeetingMinder.find(:all)
  end

  def show
    @meeting_minder = MeetingMinder.find(params[:id])
  end

  def new
    @meeting_minder = MeetingMinder.new
  end

  def edit
    @meeting_minder = MeetingMinder.find(params[:id])
  end

  def create
    @meeting_minder = MeetingMinder.new(params[:meeting_minder])

    if @meeting_minder.save
      flash[:notice] = 'MeetingMinder was successfully created.'
      redirect_to({:action => "show", :id => @meeting_minder.id})
    else
      render :action => "new"
    end
  end

  def update
    @meeting_minder = MeetingMinder.find(params[:id])

    if @meeting_minder.update_attributes(params[:meeting_minder])
      flash[:notice] = 'MeetingMinder was successfully updated.'
      redirect_to({:action => "show", :id => @meeting_minder.id})
    else
      render :action => "edit"
    end
  end

  def destroy
    @meeting_minder = MeetingMinder.find(params[:id])
    @meeting_minder.destroy

    redirect_to({:action => "index"})
  end
end
