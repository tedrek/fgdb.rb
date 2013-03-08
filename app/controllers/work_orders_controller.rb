class WorkOrdersController < ApplicationController
  layout :with_sidebar

  protected
  def get_required_privileges
    a = super
    a << {:privileges => ['techsupport_workorders']}
    return a
  end
  before_filter :ensure_metadata
  def ensure_metadata
    @@rt_metadata ||= _parse_metadata_wo
    @rt_metadata = @@rt_metadata
  end
  public

  def index
    @work_orders = [OpenStruct.new]
  end

  def new
    if params[:open_struct]
      @work_order = OpenStruct.new(params[:open_struct])
      @work_order.issues = params[:open_struct][:issue].to_a.select{|x| x.first == x.last}.map{|x| x.first}
#      @work_order.issue = nil
    else
      @work_order = OpenStruct.new
    end
    if params[:mode]
      @work_order.mode = params[:mode]
    end
  end

  def edit
    @work_order = OpenStruct.new
  end

  def show
    if params[:id]
      json = `#{RAILS_ROOT}/script/fetch_ts_data.pl #{params[:id].to_i}`
      begin
        @data = JSON.parse(json)
      rescue
        @data = nil
      end
      if @data.nil? || @data["ID"].to_i != params[:id].to_i
        @data = nil
        @error = "The provided ticket number does not exist."
        return
      end
      if @data && @data["Queue"] != "TechSupport"
        @data = nil
        @error = "The provided ticket number does not reference a valid TechSupport ticket."
        return
      end
      if @data && @data["System ID"]
        @system = System.find_by_id(@data["System ID"].to_i)
      end
    end
  end

  OS_OPTIONS = ['Linux', 'Mac', 'Windows']


  def get_system_info
    @system = System.find_by_id(params[:id].to_i)
    render :update do |page|
      if @system
        if (ge = @system.last_gizmo_event)
          trans = ge.my_transaction
          page << "$('open_struct_sale_id').value = '" + trans.id.to_s + "';"
          page << "$('open_struct_sale_date').value = '" + ge.occurred_at.to_date.to_s + "';"
          if trans.contact
            page << "$('open_struct_adopter_name').value = '" + trans.contact.display_name + "';"
            page << "$('open_struct_adopter_id').value = '" + trans.contact_id.to_s + "';"
            page << "$('open_struct_phone_number').value = '" + trans.contact.phone_number.to_s + "';"
            page << "$('open_struct_email').value = '" + trans.contact.mailing_list_email.to_s + "';"
          end
          source = trans.class == Sale ? source = "Store" : trans.disbursement_type.description
          page << "$('open_struct_box_source').value = '" + source + "';"
          desc = ge.gizmo_type.description
          b_type = ""
          if desc.match(/Mac/)
            if desc.match(/Laptop/)
              b_type = "Mac Laptop"
            else
              b_type = "Mac"
            end
          elsif desc.match(/Laptop/)
            b_type = "Laptop"
          elsif desc.match(/Server/)
            b_type = "Server"
          elsif desc.match(/System/)
            b_type = "Desktop"
          else
            b_type = "Other Gizmo" # or Desktop?
          end
          page << "$('open_struct_box_type').value = '" + b_type + "';"
        end
      end
      page.hide loading_indicator_id("system_info")
    end
  end

  def get_warranty_info
    date = params[:sale_date]
    begin
      date = Date.parse(date)
    rescue
      date = nil
    end
    b_type = params[:box_type]
    source = params[:box_source]
    os = params[:os]
    render :update do |page|
      if date
        wl = WarrantyLength.find_warranty_for(date, b_type, source, os)
        if wl && wl.eval_length
          ret = wl.is_in_warranty(date)
          page << "$('open_struct_warranty').value = '" + (ret ? "In Warranty" : "Out of Warranty" ) + "';"
        end
      end
      page.hide loading_indicator_id("warranty_info")
    end
  end

  protected

  def parse_data
    @work_order = OpenStruct.new(params[:open_struct])
    @work_order.issues = params[:open_struct][:issue] if params[:open_struct] #.to_a.select{|x| x.first == x.last}.map{|x| x.first}
#    @work_order.issue = nil

    @data = {}
    @data["Issues"] = @work_order.issues #.join(", ")
    @data["Name"] = @work_order.customer_name
    @data["Adopter Name"] = @work_order.adopter_name
    @data["ID"] = " not yet created"
    @data["Email"] = @work_order.email
    @data["Phone"] = @work_order.phone_number
    @data["OS"] = @work_order.os
    @data["Box Source"] = @work_order.box_source
    @data["Ticket Source"] = @work_order.ticket_source
    @data["Type of Box"] = @work_order.box_type
    @data["Warranty"] = @work_order.warranty
    @data["Adopter ID"] = @work_order.adopter_id
    @data["System ID"] = @work_order.system_id
    @data["Transaction Date"] = @work_order.sale_date
    @data["Transaction ID"] = @work_order.sale_id
    @data["Initial Content"] = @work_order.comment.to_s
    if !@work_order.os.to_s.empty?
      @data["Initial Content"] = "Operating system info provided: " + @work_order.os + "\n" + @data["Initial Content"]
    end
    if !@work_order.additional_items.to_s.empty?
      @data["Initial Content"] = "Additional items left with tech support: " + @work_order.additional_items + "\n" + @data["Initial Content"]
    end

    if !(@contact = Contact.find_by_id(@work_order.receiver_contact_id.to_i))
      @data = nil
      @error = "The provided receiver/technician contact doesn't exist."
      return
    else
      @data["Technician ID"] = @contact.id.to_s
    end
      if (!@contact.user) or (!(@contact.user.privileges.include?("techsupport_workorders") or @contact.user.grantable_roles.include?(Role.find_by_name('ADMIN'))))
        @data = nil
        @error = "The provided technician contact doesn't have the tech support role."
        return
      end

  end

  public
  def create
    parse_data
    if params[:mode]
      @work_order.mode = params[:mode]
    end
#    if @work_order.save
#      flash[:notice] = 'OpenStruct was successfully created.'
#      redirect_to({:action => "show", :id => @work_order.id})
#    else
#      render :action => "new"
#    end
  end

  def submit
    parse_data

    unless @error

    requestor = User.current_user ? (User.current_user.email || "") : ""
    @data["Requestor"] = requestor

    tempfile = `mktemp -p #{File.join(RAILS_ROOT, "tmp", "tmp")}`.chomp 
    f = File.open(tempfile, 'w+')
    json = @data.to_json
    f.write(json)
    f.close

    t_id = `#{RAILS_ROOT}/script/create_work_order.pl #{tempfile}`
    File.delete(tempfile)
    redirect_to :action => :show, :id => t_id, :contact_id => current_user ? current_user.contact_id : nil

    end
  end

  def update
    @work_order = OpenStruct.new

    if @work_order.update_attributes(params[:open_struct])
      flash[:notice] = 'OpenStruct was successfully updated.'
      redirect_to({:action => "show", :id => @work_order.id})
    else
      render :action => "edit"
    end
  end

  def destroy
    @work_order = OpenStruct.new
    @work_order.destroy

    redirect_to({:action => "index"})
  end
end
