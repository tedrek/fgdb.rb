class ContactDuplicatesController < ApplicationController
  layout :with_sidebar

  def index
    list_dups
    render :action => "list_dups"
  end

  def show_dups
    requires_role('ROLE_CONTACT_MANAGER')
    if params[:ids]
      @contacts = params[:ids]
    elsif params[:dup_check]
      @contacts = ContactDuplicate.find_all_by_dup_check(params[:dup_check]).map(&:contact)
    else
      @contacts = []
    end
    @contacts.collect!{|x| Contact.find_by_id(x)}
  end

  def combine_dups
    requires_role('ROLE_CONTACT_MANAGER')
    keepers = params["ids"].to_a.select{|x| x[1]["keeper"]}.map{|x| x[0].to_i}
    mergers = params["ids"].to_a.select{|x| x[1]["merge"]}.map{|x| x[0].to_i}
    if keepers.length != 1
      @error = "You must choose 1 keeper"
      return
    end
    if (keepers & mergers).length != 0
      @error = "A keeper cannot also be merged"
      return
    end
    if mergers.length == 0
      @error = "You must choose at least 1 record to be merged"
      return
    end
    @keeper = Contact.find_by_id(keepers[0])
    if !@keeper
      @error = "The keeper doesn't exist"
      return
    end
    oops = false
    @mergers = mergers.map{|x| Contact.find_by_id(x) || oops = true}
    if oops
      @error = "One of the to be merged records does not exist"
      return
    end
    @keeper.merge_these_in(@mergers)
  end

  def list_dups
    @duplicates = ContactDuplicate.list_dups().paginate(:page => params[:page])
  end
end
