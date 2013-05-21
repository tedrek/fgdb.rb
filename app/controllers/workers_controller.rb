require 'barby'
require 'barby/outputter/rmagick_outputter'
require 'stringio'
require "prawn"
require 'prawn/labels'

Prawn::Labels.types = {
  "Avery5390" => {
    "paper_size" => "LETTER",
    "top_margin" => 76.5,
    "bottom_margin" => 76.5,
    "left_margin" => 54,
    "right_margin" => 54,
    "columns" => 2,
    "rows" => 4,
    "column_gutter" => 0,
    "row_gutter" => 0,
    "vertical_text" => true
  }}

class WorkersController < ApplicationController
  protected
  def get_required_privileges
    a = super
    a << {:privileges => ['manage_workers']}
    a
  end
  public

  def index
    list
    render :action => 'list'
  end


#<%= worker ? (worker.contact ? worker.contact.first_name + "<br />" + worker.contact.surname : worker.name.sub(" ", "<br />")) : "No Worker" %>
#
#<% if worker && worker.contact %>
#<% n = worker.contact_id.to_s %>
#<% while n.length < 6 %>
#<% n = "0" + n %>
#<% end %>
#<%= barcode(worker.contact_id) %><br />
##<%= n %>
#<% end %>
#
#<img style="margin-top: 15px;" width="135px;" height="180px" src="/images/workers/<%= worker ? worker.id : 0 %>.png" />

  def badge
    if params[:workers]
      @workers = Worker.find_all_by_id(params[:workers].map{|x| x.first.to_i}).sort_by(&:name)
    end
  end

  private
  def generate_badge
    contacts = ["Ryan", "Richard", "Intern", "Test", "Ryan", "Richard", "Intern", "Test"]

    Prawn::Labels.generate("hello_labels.pdf", contacts, :type => "Avery5390") do |pdf, contact|
      top_h = 5 * pdf.bounds.height / 7.0
  low_h = 2 * pdf.bounds.height / 7.0
      name = contact # FIXME
      pdf.bounding_box [0, top_h + low_h], :height => top_h, :width => pdf.bounds.width do
        mode = "vol"
        if mode == "staff"
          one_w = 2 * pdf.bounds.width / 9.0
          two_w = 7 * pdf.bounds.width / 9.0
          pdf.bounding_box [0, pdf.bounds.height], :width => one_w, :height => pdf.bounds.height do
            pdf.y -= 2
            pdf.text "STAFF", :size => 32, :align => :center
          end
          pdf.bounding_box [one_w, pdf.bounds.height], :width => two_w, :height => pdf.bounds.height do
            pdf.image "60011.png", :position => :center, :fit => [two_w - 10, pdf.bounds.height - 26]
            pdf.y -= 2
            pdf.bounding_box [0, 26], :width => two_w - 10, :height => 26 do
              pdf.text "Date issued: " + Date.today.strftime("%m/%d/%y"), :size => 8, :align => :right
            end
          end
        else
          pdf.text "Foo Bar Intern", :size => 32, :height => pdf.bounds.height - 26, :valign => :center, :align => :center
          pdf.y -= (32 * 2)
          pdf.text "Date issued: " + Date.today.strftime("%m/%d/%y"), :size => 8, :align => :center
        end
      end
      pdf.bounding_box [0, low_h], :height => low_h, :width => pdf.bounds.width do
        one_w = 3 * pdf.bounds.width / 9.0
        two_w = 6 * pdf.bounds.width / 9.0
        pdf.bounding_box [0, pdf.bounds.height], :width => one_w, :height => pdf.bounds.height do
          pdf.image "/var/www/fgdb.rb/public/images/freegeeklogo.png", :fit => [pdf.bounds.width - 10, low_h], :vposition => :center, :position => :center
        end
        pdf.bounding_box [one_w, pdf.bounds.height], :width => two_w, :height => pdf.bounds.height do
          pdf.text "Ryan\nNiebur", :align => :center
          pdf.image StringIO.new((Barby::Code39.new("055010")).to_png(:margin => 0)), :height => 20, :width => two_w - 40, :position => :center
          pdf.y -= 5
          pdf.text "#055010", :align => :center
        end

      end
      #  pdf.stroke_color "000000"
      #  pdf.stroke_bounds # TODO: removeme
    end
    # FIXME:
    send_data pdf.render, :filename => filename,
                    :type => "application/pdf"
  end
  public

  def upload
    @worker = Worker.find_by_id(params[:id])
    dir = RAILS_ROOT + "/public/images/workers/"
    filename = dir + "#{@worker.id}.png"
    if !File.writable?(dir)
      @error = "Cannot write to #{filename}"
    end
    if @error.nil? && (io = params[:picture])
      File.unlink(filename) if File.exists?(filename)
      File.open(filename, 'w') do |f|
        f.write(io.read)
      end
    end
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @workers = Worker.paginate :order => 'name', :per_page => 20, :page => params[:page]
  end

  def show
    @worker = Worker.find(params[:id])
  end

  def new
    @worker = Worker.new
  end

  def create
    @worker = Worker.new(params[:worker])
    @worker.salaried = _parse_checkbox(params[:worker][:salaried])
    if @worker.save
      flash[:notice] = 'Worker was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @worker = Worker.find(params[:id])
    session["shift_return_to"] = "workers"
    session["shift_return_action"] = "edit"
    session["shift_return_id"] = @worker.id 
  end
  protected
  def _parse_checkbox(val)
    val = val.to_s
    if val == "1"
      return true
    elsif val == "0"
      return false
    else
      return nil
    end
  end
  public
  def update
    @worker = Worker.find(params[:id])
    @worker.salaried = _parse_checkbox(params[:worker][:salaried])
    if @worker.update_attributes(params[:worker])
      flash[:notice] = 'Worker was successfully updated.'
      redirect_to :action => 'show', :id => @worker
    else
      render :action => 'edit'
    end
  end

  def destroy
    Worker.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
