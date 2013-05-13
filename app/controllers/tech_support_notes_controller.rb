class TechSupportNotesController < ApplicationController
  protected
  def get_required_privileges
    a = super
    a << {:privileges => ['role_admin'], :except => ['find_footnotes']}
    a << {:privileges => ['techsupport_workorders'], :only => ['find_footnotes']}
    a
  end
  public

  # first on WO, then edit, then save, then dynamically too

  # TODO: later
  def find_footnotes
    render :update do |page|
      page.hide loading_indicator_id("footnote-#{@date}")
      page.replace_html "fieldset-footnote-#{@date}", :partial => "work_shifts/footnote", :locals => {:display_link => true, :note => @footnote.note.strip.empty? ? nil : @footnote, :current_date => @date, :schedule_id => @schedule, :vacs => @vacs}
    end
    
  end

  def add_note
    @name = params[:id]
    @contacts = TechSupportNote.contacts_without_notes(@name)
    render :update do |page|
      page.hide loading_indicator_id("ts-new-note")
      page.replace_html "ts-note-new", :partial => "new_note"
    end
  end

  def new_note_form
    name = params[:name]
    cid = params[:id]
    if cid
      @contact = Contact.find(cid)
    else
      @contact = _create_contact(name)
    end
    render :update do |page|
      page.hide loading_indicator_id("ts-new-note")
      page.replace_html "ts-note-new", :partial => "note_form"
    end
  end

  def save_note
    note_t = params[:notes]
    name = params[:name]
    cid = params[:id]
    if cid
      @contact = Contact.find(cid)
    else
      @contact = _create_contact(name)
      @contact.save
    end
    note = @contact.tech_support_note
    if note
      note.notes = note_t
      note.save
    else
      note = @contact.create_tech_support_note(:notes => note_t)
      note.save
    end
    # TODO: render fieldset contact
    render :update do |page|
#      page.hide loading_indicator_id("footnote-#{@date}")
#      page.replace_html "fieldset-footnote-#{@date}", :partial => "work_shifts/footnote", :locals => {:display_link => true, :note => @footnote.note.strip.empty? ? nil : @footnote, :current_date => @date, :schedule_id => @schedule, :vacs => @vacs}
      page.alert("Success!")
    end

  end

  private
  def _create_contact(name)
    contact = Contact.new
    surname = name.split(" ")
    firstname = surname.shift
    surname = surname.join(" ")
    contact.first_name = firstname
    contact.surname = surname
    return contact
  end
  public

  def edit_note
    cid = params[:id]
    @contact = Contact.find(cid)
    @note = @contact.tech_support_note

    render :update do |page|
      page.replace_html "ts-note-#{@contact.id}", :partial => "note_form"
      page.hide loading_indicator_id("ts-new-note") # FIXME
    end
  end
end
