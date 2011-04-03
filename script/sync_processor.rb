#!/usr/bin/ruby

# Api's we will use:
## http://wiki.civicrm.org/confluence/display/CRMDOC33/Contact+APIs
## http://wiki.civicrm.org/confluence/display/CRMDOC33/Contribution+APIs

require 'json'
require 'net/http'
require 'uri'
require File.dirname(__FILE__) + '/../config/boot'
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")

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
    @server + "/drupal6"
  end

  #               ex: "fgdb_donations" "fgdb_donation_id"
  def custom_field_id(group_name, field_name)
    group_id = self.do_req("civicrm/custom/get_group_id", "group_name=#{group_name}")["result"]
    return self.do_req("civicrm/custom/get_field_id", "group_id=#{group_id}&field_name=#{field_name}")["result"]
  end

  def do_req(func, opts)
    get("http://#{server}/sites/all/modules/civicrm/extern/rest.php?q=#{func}&json=1&key=#{@site_key}&api_key=#{@key}&#{opts}")
  end

  private
  def get(url)
    ret = JSON.parse(Net::HTTP.get(URI.parse(url)))
    raise ret["error_message"] if ret.class == Hash and ret["is_error"] == 1
    ret
  end
end

# TODO: impliment these sync_ functions. they return nil if it was not successful.

def sync_donation_from_fgdb(fgdb_id)
  civicrm_id = nil
  civicrm_id = 1
  return civicrm_id
end

def sync_contact_from_fgdb(fgdb_id)
  civicrm_id = nil
  my_client = CiviCRMClient.from_defaults
  my_custom = my_client.custom_field_id("fgdb_contacts", "fgdb_contact_id")
  find_arr = my_client.do_req("civicrm/contact/get", "custom_#{my_custom}=#{fgdb_id}")
  civicrm_id = (find_arr.class == Array) ? find_arr.first["contact_id"] : nil
  c = Contact.find(fgdb_id)
  hash = {}
  if c.is_organization
    hash[:contact_type] = "Organization"
    hash[:organization] = c.organization
  else
    hash[:contact_type] = "Individual"
    hash[:first_name] = c.first_name
    hash[:middle_name] = c.middle_name
    hash[:last_name] = c.surname
  end
  if civicrm_id
    hash[:contact_id] = civicrm_id
    my_client.do_req("civicrm/contact/update", hash.r_to_params)
  else
    hash["custom_#{my_custom}"] = fgdb_id
    civicrm_id = my_client.do_req("civicrm/contact/create", hash.r_to_params)["contact_id"]
  end
  return civicrm_id
end

# set @saved_civicrm to true if we save the civicrm record too. we might do this to set the fgdb_id field if this is the first sync to fgdb.

def sync_donation_from_civicrm(civicrm_id)
  fgdb_id = nil
  fgdb_id = 1
  return fgdb_id
end

def sync_contact_from_civicrm(civicrm_id)
  fgdb_id = nil
  fgdb_id = 1
  return fgdb_id
end

def do_main
  success = false
  fgdb_id = nil
  civicrm_id = nil
  source, table, tid = ARGV
  @saved_civicrm = false

  if source == "civicrm" && system(ENV["SCRIPT"], "find", "skip_civicrm", table, tid)
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

  if success
    system(ENV["SCRIPT"], "rm", source, table, tid) or raise Exception
    if source == "civicrm"
      system(ENV["SCRIPT"], "rm", "fgdb", table, fgdb_id.to_s) or raise Exception
      if @saved_civicrm
        system(ENV["SCRIPT"], "add", "skip_civicrm", table, civicrm_id.to_s) or raise Exception
      end
    else # source == "fgdb"
###      system(ENV["SCRIPT"], "add", "skip_civicrm", table, civicrm_id.to_s) or raise Exception ### FIXME: uncomment this once it is actually doing some syncing
    end
  else
    system(ENV["SCRIPT"], "take_a_break") or raise Exception
  end
end

if $0 == __FILE__
  do_main
end

