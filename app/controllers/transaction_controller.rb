require 'pdf/writer'
require 'pdf/simpletable'

class TransactionController < ApplicationController
  layout :check_for_receipt

  helper :raw_receipt

  before_filter :set_defaults
  before_filter :be_a_thing

  include RawReceiptHelper

  def raw_receipt
    printer = (params[:receipt] ? params[:receipt][:printer] : "")
    render :update do |page|
      raise unless params[:controller] == 'sales'
      s = Sale.find_by_id(params[:id])
      receipt_printer_set_default(printer)
      handle_java_print(page, generate_raw_receipt(printer) {|limit| s.text_receipt_lines(limit)}, {:alert => s.storecredit_alert_text, :loading => "raw_receipt_loading_indicator_id"})
    end
  end

  protected

  def set_defaults
    @action_name=action_name
    @return_to_search = "false"
  end

  def be_a_thing
    set_transaction_type((controller_name()).singularize)
  end

  def get_required_privileges
    a = super
    fn = self.class.to_s.tableize.gsub(/_controllers$/, "")
    a << {:only => ["/show_created_and_updated_by"], :privileges => ['role_admin']}
    a << {:only => ["search", "component_update", "receipt"], :privileges => ["view_#{fn}"]}
    a << {:only => ["edit", "destroy", "update"], :privileges => ["change_#{fn}"]}
    a << {:except => ["civicrm_sync", "receipt", "edit", "destroy", "update", "search", "component_update"], :privileges => ["create_#{fn}"]}
    a
  end

  def check_for_receipt
    case action_name
    when /(receipt|mail_pdf)/ then "receipt_invoice.html.erb"
    else                "with_sidebar.html.erb"
    end
  end

  public

  def get_system_contract
    s = nil
    if params[:system_id].to_s == params[:system_id].to_i.to_s
      s = System.find_by_id(params[:system_id])
    end
    v = (s ? s.contract_id : -1)
    v2 = (s ? s.covered : nil)

    render :update do |page|
      page << "internal_system_contract_id = #{v.to_s.to_json}";
      page << "system_covered_cache[#{params[:system_id].to_json}] = #{v2.inspect.to_json}";
      page << "ge_done();"
    end
  end

  def get_storecredit_amount
    s = nil
    begin
      scid = StoreChecksum.new_from_checksum(params[:id]).result
      s = StoreCredit.find_by_id(scid)
    rescue StoreChecksumException
    end # else below..
    msg = nil
    v = -1
    if s
      if s.spent?
        msg = "This store credit has already been spent"
      else
        v = s.amount_cents
        if !s.still_valid?
          msg = "This store credit is expired. It expired on #{s.expire_date.strftime("%D")}. This software will allow it anyway, but you possibly should not."
        end
      end
    else
      msg = "That store credit hash is not valid or doesn't exist"
    end
    v = (s && !s.spent? ? s.amount_cents : -1)
    render :update do |page|
      page << "internal_storecredit_amount = #{v.to_s.to_json};";
      page << "storecredit_errors_cache[#{params[:id].to_json}] = #{msg.to_json};"
      page.hide     params[:loading] # loading_indicator_id("payment_line_item")
    end
  end

  def get_sale_exists
    s = Sale.find_by_id(params[:id])
    s = !! s
    render :update do |page|
      page << "internal_sale_exists = #{s.to_json};";
      page.hide loading_indicator_id("line_item")
    end
  end

  def get_disbursement_exists
    s = Disbursement.find_by_id(params[:id])
    s = !! s
    render :update do |page|
      page << "internal_disbursement_exists = #{s.to_json};";
      page.hide loading_indicator_id("line_item")
    end
  end

  def update_stuff
    @show_wrapper = false
    params[:continue] = false
  end

  def component_update
    update_stuff
    search
  end

  def search
    @show_wrapper = true if @show_wrapper.nil?
    @conditions = Conditions.new
    @model = model
    if params[:dont_show_wrapper]
      update_stuff
    end

    if params[:continue] && !session[:search_bookmark].nil?
      params[:conditions] = session[:search_bookmark][:conditions]
      params[:page] = session[:search_bookmark][:page]
    end

    if params[:conditions] == nil
      params[:conditions] = {}
      @transactions = nil
      session[:search_bookmark] = nil
    else
      @sort_sql = @model.default_sort_sql
      @conditions.apply_conditions(params[:conditions])

      search_options = {
        :order => @sort_sql,
        :per_page => 20,
        :include => [:gizmo_events],
        :conditions => @conditions.conditions(@model),
        :page => params[:page]
      }

      if @model.new.respond_to?( :payments )
        search_options[:include] << :payments
      end

      session[:search_bookmark] = {
        :conditions => params[:conditions],
        :page => params[:page]
      }
      @transactions = @model.paginate( search_options )
    end

    @return_to_search = "true"

    render :action => "search", :layout => @show_wrapper
  end

  def index
    new
    render :action => 'new'
  end

  private
  def new_trans_init_hook
  end
  public

  def new
    @transaction ||= model.new(params[@gizmo_context.name.to_sym])
    new_trans_init_hook
    @successful ||= true

    @conditions = Conditions.new
    @conditions.apply_conditions((default_condition + "_enabled") => "true")
    @transactions = model.find(:all, :conditions => @conditions.conditions(model), :limit => 15, :order => default_condition + " DESC")
  end

  def create
    begin
      @transaction = model.new(params[@transaction_type])
      _apply_line_item_data(@transaction)
      @successful =  @transaction.save
    rescue
      flash[:error], @successful = $!.to_s + "<hr />" + $!.backtrace.join("<br />").to_s, false
    end

    render :action => 'create.rjs'
  end

  def create_without_ajax
    begin
      @transaction = model.new(params[@transaction_type])
      _apply_line_item_data(@transaction)
      @successful =  @transaction.save
    rescue
      flash[:error], @successful = $!.to_s + "<hr />" + $!.backtrace.join("<br />").to_s, false
    end
    if @successful
      if @transaction_type == "sale" or (@transaction_type == "donation" and @transaction.contact_type != "dumped")
        @receipt = @transaction.id
      end
      @transaction = model.new
    end
    new
    render :action => 'new'
  end

  def edit
    begin
      @transaction = model.find(params[:id])
      @successful = !@transaction.nil?
      @initial_page_load = true
    rescue
      flash[:error], @successful = $!.to_s, false
    end

    @return_to_search = params[:return_to_search] == "true"

    @conditions = Conditions.new
    @conditions.apply_conditions((default_condition + "_enabled") => "true")
    @transactions = model.find(:all, :conditions => @conditions.conditions(model), :limit => 15, :order => default_condition + " DESC")
  end

  def update
    begin
      @transaction = model.find(params[:id])
      @transaction.attributes = params[@transaction_type]
      _apply_line_item_data(@transaction)
      @successful =  @transaction.save
    rescue
      flash[:error], @successful  = $!.to_s + "<hr />" + $!.backtrace.join("<br />").to_s, false #, false #
    end

    render :action => 'update.rjs'
  end

  def update_without_ajax
    begin
      @transaction = model.find(params[:id])
      @transaction.attributes = params[@transaction_type]
      _apply_line_item_data(@transaction)
      @successful =  @transaction.save
    rescue
      flash[:error], @successful  = $!.to_s + "<hr />" + $!.backtrace.join("<br />").to_s, false #, false #
    end

    if @successful
      if @transaction_type == "sale" or (@transaction_type == "donation" and @transaction.contact_type != "dumped")
        @receipt = @transaction.id
      end
      @transaction = model.new
    end

    new
    render :action => 'new'
  end

  def destroy
    begin
      @successful = model.find(params[:id]).destroy
    rescue
      @error = $!.to_s
      @successful = false
      flash[:error], @successful  = $!.to_s, false
    end
    render :action => "destroy.rjs"
  end

  def needs_attention
    begin
      @transaction = model.find(params[:id])
      @transaction.comments += "\nATTN: #{params[:comment]}"
      @transaction.needs_attention = true
      @successful = @transaction.save
    rescue
      flash[:error], @successful = $!.to_s, false
    end
  end

  def cancel
    @successful = true

    return render(:action => 'cancel.rjs')
  end

  def update_discount_schedule
    if params[@transaction_type][:contact_id]
      default_discount_schedule = Contact.find(params[@transaction_type][:contact_id]).default_discount_schedule
    else
      default_discount_schedule = DiscountSchedule.no_discount
    end
    render :update do |page|
      page << "set_new_val($('#{@transaction_type}_discount_schedule_id'), '#{default_discount_schedule.id}');"
    end
  end

  def mail_pdf
    pdf = gen_pdf
    data = pdf.render
    filename = "receipt_#{params[:id]}.pdf"
    address = nil
    if params[:address_choice] == 'other'
      address = params[:address]
      if params[:save]
        ContactMethod.new(:contact_id => @txn.contact_id, :contact_method_type_id => params[:contact_method_type_id], :value => address, :ok => true).save!
      end
    else
      address = ContactMethod.find_by_id(params[:address_choice].sub(/contact_method_/, '')).value
    end
    Notifier.deliver_donation_pdf(address, data, filename)
    @message = "Sent receipt to #{address}"
    receipt
    render :action => 'receipt'
  end

  protected
  def gen_pdf
    @txn = @transaction = model.find(params[:id])
    @context = @transaction_type
    raise unless @context == 'donation'

    pdf = PDF::Writer.new
    pdf.select_font("Helvetica")

    pdf.start_columns 4, 0
    pdf.image RAILS_ROOT + "/public/images/freegeeklogo.png", :justification => :left
    pdf.start_new_page
    pdf.image RAILS_ROOT + "/public/images/hdr-address.png", :justification => :left, :resize => 1.5
    pdf.start_new_page
    pdf.start_new_page
    pdf.text "Anon - BLAH"
    pdf.stop_columns

    pdf.y -= 5     # - moves down.. coordinate system is confusing, starts bottom left

    pdf.stroke_color! Color::RGB::Black
    pdf.line(pdf.absolute_left_margin, pdf.y, pdf.absolute_right_margin, pdf.y).stroke

    PDF::SimpleTable.new do |tab|
      tab.font_size = 14
        tab.width = pdf.absolute_right_margin - pdf.absolute_left_margin # (PDF::Writer::PAGE_SIZES["A4"][2].to_i - 60)
        tab.column_order.push(*%w(one two three))

        tab.columns["one"] = PDF::SimpleTable::Column.new("one") { |col|

        }
        tab.columns["two"] = PDF::SimpleTable::Column.new("two") { |col|
        }
        tab.columns["three"] = PDF::SimpleTable::Column.new("three") { |col|
        col.justification = :left
        }

        tab.show_lines    = :none
        tab.show_headings = false
        tab.shade_rows  = :none
        tab.orientation   = :center
        tab.position      = :center

        data = [
                { "one" => "Donation Receipt", "three" => "Federal Tax I.D. 93-1292010" }, # TODO: pull tax id from Defaults ?
                { "one" => "Created by #" }, # TODO: fixme
                { "one" => "Date: #{@txn.occurred_at.strftime("%m/%d/%Y")}", "two" => "Donation ##{@txn.id}"},
          ]

        tab.data.replace data
        tab.render_on(pdf)
      end

    PDF::SimpleTable.new do |tab|
      tab.font_size = 14
        tab.width = pdf.absolute_right_margin - pdf.absolute_left_margin # (PDF::Writer::PAGE_SIZES["A4"][2].to_i - 60)
        tab.column_order.push(*%w(qty desc val))

        tab.columns["qty"] = PDF::SimpleTable::Column.new("qty") { |col|
        col.heading = "Quantity:"
        }
        tab.columns["desc"] = PDF::SimpleTable::Column.new("desc") { |col|
        col.heading = "Description:"
        }
        tab.columns["val"] = PDF::SimpleTable::Column.new("val") { |col|
        col.heading = "Est Value:"
        }

        tab.show_lines    = :all
        tab.show_headings = true

        tab.orientation   = :center
        tab.position      = :center
      # TODO : compare all logic with actual receipt
      data = @txn.gizmo_events.map{|x| {"qty" => x.gizmo_count, "desc" => x.attry_description, "val" => "______"}}
      data << {"desc" => " "}
      data << {"desc" => "Total Estimated Value (tax deductible):", "val" =>  "_________"}
      data << {"desc" => "Cash:", "val" =>  "$3.00"} # FIXME: payments processing
      data << {"desc" => "Donation Paid (tax deductible):", "val" =>  "$3.00"}
      data << {"desc" => "Total Deductible Donation:", "val" =>  "_________"}

        tab.data.replace data
        tab.render_on(pdf)
      end

#    pdf.hline
#    pdf.save_state
#    pdf.stroke_style PDF::Writer::StrokeStyle::DEFAULT
#    pdf.stroke_color! Color::RGB::Black
#    
#    pdf.stroke
#    pdf.restore_state

    pdf.text "Comments: BLAH IF SO", :font_size => 14
    # <HR />, however..
    pdf.y -= 5
    pdf.stroke_color! Color::RGB::Black
    pdf.line(pdf.absolute_left_margin, pdf.y, pdf.absolute_right_margin, pdf.y).stroke
    pdf.text "We affirm that no goods or services were provided in return for the donation amounts listed above (required fees excepted).", :font_size => 14

#    pdf.y -= 10
#    pdf.text "Hello, Ruby.", :font_size => 72, :justification => :center

#       pdf.save_as('public/output.pdf')
    return pdf
  end
  public
  def pdf
    pdf = gen_pdf
    send_data pdf.render, :filename => "receipt_#{params[:id]}.pdf",
                    :type => "application/pdf"
  end

  def receipt
    @txn = @transaction = model.find(params[:id])
    @context = @transaction_type
  end

  #######
  private
  #######

  def set_transaction_type(type)
    @transaction_type = type
    @gizmo_context = GizmoContext.send(@transaction_type) or raise "UGH"
  end

  def totals_id(params)
    @transaction_type + '_totals_div'
  end

  def model
    case @transaction_type
    when 'donation'
      Donation
    when 'sale'
      Sale
    when 'disbursement'
      Disbursement
    when 'recycling'
      Recycling
    when 'gizmo_return'
      GizmoReturn
    else
      raise "UNKNOWN TX-TYPE #{@transaction_type}"
    end
  end

  def _apply_line_item_data(transaction)
    if transaction.respond_to?(:payments)
      @payments = []
      payments = params[:payments] || {}
      for payment in payments.values
        p = Payment.new(payment)
        @payments << p
      end
      @transaction.payments = @payments
      transaction.payments.delete_if {|pmt| pmt.mostly_empty?}
    end
    params[:gizmo_events].values.each{|x| x[:gizmo_count] ||= 1} if @gizmo_context == GizmoContext.gizmo_return and params[:gizmo_events]
    if transaction.respond_to?(:gizmo_events)
      lines = params[:gizmo_events] || {}
      @lines = []
      for line in lines.values
        @lines << GizmoEvent.new_or_edit(line.merge({:gizmo_context => @gizmo_context}))
      end
      @transaction.gizmo_events = @lines
    end
    transaction.gizmo_events.delete_if {|gizmo| gizmo.mostly_empty?}
  end
end
