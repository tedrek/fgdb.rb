
#!/usr/bin/ruby

# Api's we will use:
## http://wiki.civicrm.org/confluence/display/CRMDOC33/Contact+APIs
## http://wiki.civicrm.org/confluence/display/CRMDOC33/Contribution+APIs
## http://wiki.civicrm.org/confluence/display/CRMDOC33/Custom+Data+Group+and+Custom+Field+APIs
### setup script with fgdb that calls civicrm_custom_group_create and
### civicrm_custom_field_create to add fgdb_id field to contributions and
### contacts, and saves the ['id'] of the fields into the defaults
### table so we know what to look for later. two birds, one stone.
## civicrm/custom/get_group_id?group_name=asdf
## civicrm/custom/get_field_id?field_name=fgdb_id&group_id=1

require 'json'
require 'net/http'
require 'uri'
require File.dirname(__FILE__) + '/../config/boot'
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")

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
  civicrm_id = 1
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

