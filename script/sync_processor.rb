#!/usr/bin/ruby

# Api's we will use:
## http://wiki.civicrm.org/confluence/display/CRMDOC33/Contact+APIs
## http://wiki.civicrm.org/confluence/display/CRMDOC33/Contribution+APIs

# API explorer: http://civicrm/drupal/?q=civicrm/ajax/doc#explorer

require 'json'
require 'net/http'
require 'uri'
require File.dirname(__FILE__) + '/../config/boot'
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")

$civicrm_mode = true

class Hash
  def r_to_params
    self.map{|k,v| "#{k.to_s}=#{v.to_s}"}.join("&") # TODO: cgi escape
  end
end

class CiviCRMClient
  def CiviCRMClient.from_defaults
    CiviCRMClient.new(Default['civicrm_server'], Default['civicrm_api_key'], Default['civicrm_user_key'])
  end

  def initialize(server, api_key, user_key)
    @server = server
    @site_key = api_key
    @key = user_key
  end

  def server
    @server + "/drupal"
  end

  #               ex: "fgdb_donations" "fgdb_donation_id"

  def custom_field_id(group_name, field_name)
    res = self.do_req("civicrm/CustomField/get", "")
    hash = {}
    res["values"].each{|k,v|
      hash[v["name"]] = k
    }
    return hash[field_name.gsub(/ /, "_")]
  end

  def fgdb_field(table_name)
    custom_field_id("FGDB #{table_name.humanize} Information", "FGDB #{table_name.humanize} ID")
  end

  def do_req(func, opts = {}, version = 3)
    opts = opts.r_to_params if opts.class == Hash
    url = "http://#{server}/sites/all/modules/civicrm/extern/rest.php?version=#{version}&q=#{func}&json=1&key=#{@site_key}&api_key=#{@key}&#{opts}"
    if func.match(/get$/)
      get(url)
    else
      post(url)
    end
  end

  private
  def post(url)
    url = URI.parse(url)
    req = Net::HTTP::Post.new(url.request_uri)
    ret = Net::HTTP.start(url.host, url.port) {|http| http.request(req)}
    ret = JSON.parse(ret.body)
    raise ret["error_message"] if ret.class == Hash and ret["is_error"] == 1
    ret
  end

  def get(url)
    ret = JSON.parse(Net::HTTP.get(URI.parse(url)))
    raise ret["error_message"] if ret.class == Hash and ret["is_error"] == 1
    ret
  end
end

def sync_donation_from_fgdb(fgdb_id)
  civicrm_id = nil
  civicrm_id = 1
  return civicrm_id
end

def sync_donation_from_civicrm(civicrm_id)
  fgdb_id = nil
  fgdb_id = 1
  return fgdb_id
end


class ContactObject
  attr_accessor :is_organization, :organization
  attr_accessor :first_name, :middle_name, :last_name

  attr_accessor :address, :address_extra, :city, :state, :postal_code
  attr_accessor :phone_numbers
  attr_accessor :emails

  def contact_type
    is_organization ? "Organization" : "Individual"
  end

  def to_fgdb(c)
    c.created_by ||= 1
    c.first_name = first_name 
    c.surname = last_name 
    c.is_organization = is_organization 
    c.organization = organization 
    c.postal_code = postal_code 
  end

  def from_fgdb(c)
    self.is_organization = c.is_organization
    self.organization = c.organization
    self.first_name = c.first_name
    self.middle_name = c.middle_name
    self.last_name = c.surname
    self.postal_code = c.postal_code
  end

  def from_civicrm(civicrm_contact)
    puts civicrm_contact.inspect
    self.first_name = civicrm_contact["first_name"]
    self.middle_name = civicrm_contact["middle_name"]
    self.last_name = civicrm_contact["last_name"]
    self.is_organization = civicrm_contact["contact_type"] == "Organization"
    self.organization = civicrm_contact["organization_name"]
    self.postal_code = civicrm_contact["postal_code"]
  end

  def to_civicrm
    hash = {}
    hash[:contact_type] = contact_type
    hash[:organization_name] = organization
    hash[:first_name] = first_name
    hash[:middle_name] = middle_name
    hash[:last_name] = last_name
    hash[:postal_code] = postal_code
    return hash
  end
end

def sync_contact_from_fgdb(fgdb_id)
  civicrm_id = nil
  my_client = CiviCRMClient.from_defaults
  my_custom = my_client.fgdb_field("contact")
  find_arr = my_client.do_req("civicrm/contact/get", "custom_#{my_custom}=#{fgdb_id}")
  civicrm_id = (find_arr["count"] == 1) ? find_arr["id"] : nil

  c = Contact.find_by_id(fgdb_id)
  return nil unless c
  co = ContactObject.new
  co.from_fgdb(c)
  hash = co.to_civicrm

  if civicrm_id
    hash[:id] = civicrm_id
    # TODO: return nil for FAIL if not success
    my_client.do_req("civicrm/contact/update", hash)
  else
    hash["custom_#{my_custom}"] = fgdb_id
    ret = my_client.do_req("civicrm/contact/create", hash)
    puts ret.inspect
    civicrm_id = ret["id"]
  end

  return civicrm_id
end


def sync_contact_from_civicrm(civicrm_id)
  fgdb_id = nil
  my_client = CiviCRMClient.from_defaults
  my_custom = my_client.fgdb_field("contact")
  ret_values = my_client.do_req("civicrm/contact/get", {"contact_id" => civicrm_id, "return" => "custom_#{my_custom}"})["values"]
  return nil if ret_values.length == 0
  fgdb_id = ret_values.length > 0 ? ret_values[civicrm_id]["custom_#{my_custom}"].to_i : nil
  c = nil
  unless fgdb_id and (c = Contact.find_by_id(fgdb_id))
    fgdb_id = nil
    @saved_civicrm = true
    c = Contact.new
  end

  civicrm_contact = my_client.do_req("civicrm/contact/get", {"contact_id" => civicrm_id})["values"][civicrm_id]
#  puts my_client.do_req("civicrm/entity_tag/get", {"contact_id" => civicrm_id}).inspect # will need to create/delete if needed
#  puts my_client.do_req("civicrm/note/get", {"contact_id" => civicrm_id, "subject" => "FGDB"}).inspect # delete, then re-create it
#  puts civicrm_contact.inspect

  co = ContactObject.new
  co.from_civicrm(civicrm_contact)
  co.to_fgdb(c)
  c.save!
  if @saved_civicrm
    fgdb_id = c.id
    my_client.do_req("civicrm/contact/update", {:id => civicrm_id, :contact_type => civicrm_contact["contact_type"], "custom_#{my_custom}" => fgdb_id})
  end
  return fgdb_id
end

def do_main
  success = false
  fgdb_id = nil
  civicrm_id = nil
  source, table, tid = ARGV
  @saved_civicrm = false

  if source == "civicrm" && (ENV["SCRIPT"] && system(ENV["SCRIPT"], "find", "skip_civicrm", table, tid))
    system(ENV["SCRIPT"], "rm", source, table, tid) or raise Exception
    system(ENV["SCRIPT"], "rm", "skip_civicrm", table, tid) or raise Exception
    return
  else
    puts "Syncing #{table} ##{tid} from #{source} at #{Time.now}"
    if source == "fgdb"
      fgdb_id = tid
      success = !!(oid = civicrm_id = (table == "donations" ? sync_donation_from_fgdb(fgdb_id) : sync_contact_from_fgdb(fgdb_id)))
    else #source == "civicrm"
      civicrm_id = tid
      success = !!(oid = fgdb_id = (table == "donations" ? sync_donation_from_civicrm(civicrm_id) : sync_contact_from_civicrm(civicrm_id)))
    end
    puts "  Completed at #{Time.now}. Resulting id on #{source == "fgdb" ? "civicrm" : "fgdb"} was: #{oid.nil? ? "FAIL" : oid}"
  end

  if ENV["SCRIPT"]
  if success
    system(ENV["SCRIPT"], "rm", source, table, tid) or raise Exception
    if source == "civicrm"
      system(ENV["SCRIPT"], "rm", "fgdb", table, fgdb_id.to_s) or raise Exception
      if @saved_civicrm
        system(ENV["SCRIPT"], "add", "skip_civicrm", table, civicrm_id.to_s) or raise Exception
      end
    else # source == "fgdb"
      system(ENV["SCRIPT"], "add", "skip_civicrm", table, civicrm_id.to_s) or raise Exception
    end
  else
    system(ENV["SCRIPT"], "take_a_break") or raise Exception
  end
  end
end

if $0 == __FILE__
  do_main
end

