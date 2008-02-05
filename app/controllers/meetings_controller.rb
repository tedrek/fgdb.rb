class MeetingsController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @meeting_pages, @meetings = paginate :meetings, :order => 'name', :per_page => 20
  end

  def show
    @meeting = Meeting.find(params[:id])
  end

  def new
    @meeting = Meeting.new
  end

  def create
    @meeting = Meeting.new(params[:meeting])
    if @meeting.save
      flash[:notice] = 'Meeting was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @meeting = Meeting.find(params[:id])
  end

  def update
    @meeting = Meeting.find(params[:id])
    if @meeting.update_attributes(params[:meeting])
      flash[:notice] = 'Meeting was successfully updated.'
      redirect_to :action => 'show', :id => @meeting
    else
      render :action => 'edit'
    end
  end

  def destroy
    Meeting.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
