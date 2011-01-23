class NotesController < ApplicationController
  layout :with_sidebar

  def show
    @note = Note.find(params[:id])
  end

  def new
    @note = Note.new
    @note.system = System.find_by_id(params[:system_id])
    redirect :back if @note.system.nil?
  end

  def edit
    @note = Note.find(params[:id])
  end

  def create
    @note = Note.new(params[:note])

    if @note.save
      flash[:notice] = 'Note was successfully created.'
      redirect_to({:action => "show", :id => @note.id})
    else
      render :action => "new"
    end
  end

  def update
    @note = Note.find(params[:id])

    if @note.update_attributes(params[:note])
      flash[:notice] = 'Note was successfully updated.'
      redirect_to({:action => "show", :id => @note.id})
    else
      render :action => "edit"
    end
  end
end
