#!/usr/bin/ruby

# TODO: impliment these sync_ functions. they return nil if it was not successful.

def sync_donation_from_fgdb(fgdb_id)
  civicrm_id = nil
  return civicrm_id
end

def sync_contact_from_fgdb(fgdb_id)
  civicrm_id = nil
  return civicrm_id
end

# set @saved_civicrm to true if we save the civicrm record too. we might do this to set the fgdb_id field if this is the first sync to fgdb.

def sync_donation_from_civicrm(civicrm_id)
  fgdb_id = nil
  return fgdb_id
end

def sync_contact_from_civicrm(civicrm_id)
  fgdb_id = nil
  return fgdb_id
end

def do_main
  success = false
  fgdb_id = nil
  civicrm_id = nil
  source, table, tid = ARGV
  @saved_civicrm = false

  if source == "civicrm" && system(ENV["SCRIPT"], "find", "skip_civicrm", table, tid)
    system(ENV["SCRIPT"], "rm", source, table, tid)
    system(ENV["SCRIPT"], "rm", "skip_civicrm", table, tid)
    # success is false, the else doesn't get ran, so it falls through, as it should
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
    system(ENV["SCRIPT"], "rm", source, table, tid)
    if source == "civicrm"
      system(ENV["SCRIPT"], "rm", "fgdb", table, fgdb_id)
      if @saved_civicrm
        system(ENV["SCRIPT"], "add", "skip_civicrm", table, civicrm_id)
      end
    else # source == "fgdb"
      system(ENV["SCRIPT"], "add", "skip_civicrm", table, civicrm_id)
    end
  end
end
