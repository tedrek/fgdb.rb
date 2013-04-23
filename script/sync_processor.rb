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

# TODO: remove r_to_params

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
    return hash[field_name]
  end

  def fgdb_field(table_name)
    custom_field_id("fgdb_#{table_name}s", "fgdb_#{table_name}_id")
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

def sync_contact_from_fgdb(fgdb_id)
  civicrm_id = nil
  my_client = CiviCRMClient.from_defaults
  my_custom = my_client.fgdb_field("contact")
  find_arr = my_client.do_req("civicrm/contact/get", "custom_#{my_custom}=#{fgdb_id}")
  civicrm_id = (find_arr["count"] == 1) ? find_arr["id"] : nil
  c = Contact.find(fgdb_id)
  hash = {}
  if c.is_organization
    hash[:contact_type] = "Organization"
    hash[:organization_name] = c.organization
  else
    hash[:contact_type] = "Individual"
    hash[:first_name] = c.first_name
    hash[:middle_name] = c.middle_name
    hash[:last_name] = c.surname
  end
  if civicrm_id
    hash[:id] = civicrm_id
    # TODO: return nil for FAIL if not success
    my_client.do_req("civicrm/contact/update", hash.r_to_params)
  else
    hash["custom_#{my_custom}"] = fgdb_id
    ret = my_client.do_req("civicrm/contact/create", hash.r_to_params)
    puts ret.inspect
    civicrm_id = ret["id"]
  end
  return civicrm_id
end

def sync_donation_from_civicrm(civicrm_id)
  fgdb_id = nil
  fgdb_id = 1
  return fgdb_id
end

def sync_contact_from_civicrm(civicrm_id)
  fgdb_id = nil
  my_client = CiviCRMClient.from_defaults
  my_custom = my_client.fgdb_field("contact")
  fgdb_id = my_client.do_req("civicrm/contact/get", {"contact_id" => civicrm_id, "return_custom_#{my_custom}" => 1}.r_to_params)["values"][civicrm_id]["custom_#{my_custom}"]
  c = nil
  @double_saved = false
  unless fgdb_id and (c = Contact.find_by_id(fgdb_id))
    fgdb_id = nil
    @saved_civicrm = true
    c = Contact.new
  end
  civicrm_contact = my_client.do_req("civicrm/contact/get", {"contact_id" => civicrm_id}.r_to_params)["values"][civicrm_id]
  c.first_name = civicrm_contact["first_name"]
  c.created_by ||= 1
  puts my_client.do_req("civicrm/entity_tag/get", {"contact_id" => civicrm_id}.r_to_params).inspect # will need to create/delete if needed
  puts my_client.do_req("civicrm/note/get", {"contact_id" => civicrm_id, "subject" => "FGDB"}.r_to_params).inspect # delete, then re-create it
  puts civicrm_contact.inspect
  c.surname = civicrm_contact["last_name"]
  c.is_organization = civicrm_contact["contact_type"] == "Organization"
  c.organization = civicrm_contact["organization_name"]
  c.postal_code = civicrm_contact["postal_code"]
  if @saved_civicrm
    c.postal_code ||= "CIVICRM_UNSETME"
  end
  c.save!
  if c.postal_code == "CIVICRM_UNSETME"
    @double_saved = true
    c.postal_code = nil
    c.save!
  end
  if @saved_civicrm
    fgdb_id = c.id
    my_client.do_req("civicrm/contact/update", {:id => civicrm_id, :contact_type => civicrm_contact["contact_type"], "custom_#{my_custom}" => fgdb_id}.r_to_params)
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
      if @double_saved
        system(ENV["SCRIPT"], "rm", "fgdb", table, fgdb_id.to_s) or raise Exception
      end
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

