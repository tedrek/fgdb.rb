class BuilderTasksController < ApplicationController
  layout :with_sidebar
  protected
  def get_required_privileges
    a = super
    a << {:privileges => ['sign_off_spec_sheets']}
    a << {:only => ["/view_contact_name"], :privileges => ['manage_contacts']}
    a
  end
  public

  def sign_off
    u = User.find_by_cashier_code(params[:cashier_code])
    s = BuilderTask.find(params[:id])
    if u.has_privileges(required_privileges("sign_off").flatten.first) # if no admins, only people with actual build_instructor role, do this: u.privileges.include?(required_privileges("show/sign_off").flatten.first)
      s.signed_off_by=(u)
      s.save!
    end
    redirect_to :back
  end

  def index
    @error = params[:error]
    if !params[:conditions]
      params[:conditions] = {:created_at_enabled => "true"}
    end
    @conditions = Conditions.new
    @conditions.apply_conditions(params[:conditions])
    if @conditions.contact_enabled
      if !has_required_privileges('/view_contact_name')
        return
      end
    end
    @builder_tasks = BuilderTask.paginate(:page => params[:page], :conditions => @conditions.conditions(BuilderTask), :order => "created_at ASC", :per_page => 50)
    render :action => "index"
  end

  def show
    @builder_task = BuilderTask.find(params[:id])
  end

  def new
    @builder_task = BuilderTask.new
  end

  def edit
    @builder_task = BuilderTask.find(params[:id])
  end

  def create
    @builder_task = BuilderTask.new(params[:builder_task])

    if @builder_task.save
      flash[:notice] = 'BuilderTask was successfully created.'
      redirect_to({:action => "show", :id => @builder_task.id})
    else
      render :action => "new"
    end
  end

  def update
    @builder_task = BuilderTask.find(params[:id])

    if @builder_task.update_attributes(params[:builder_task])
      flash[:notice] = 'BuilderTask was successfully updated.'
      redirect_to({:action => "show", :id => @builder_task.id})
    else
      render :action => "edit"
    end
  end
end
