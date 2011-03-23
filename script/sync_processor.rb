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

  if source == "civicrm" && system(ENV["SCRIPT"], "find", "skip_civicrm", table, tid)
    system(ENV["SCRIPT"], "rm", source, table, tid)
    system(ENV["SCRIPT"], "rm", "skip_civicrm", table, tid)
    # success is false, the else doesn't get ran, so it falls through, as it should
  else
    if source == "fgdb"
      fgdb_id = tid
      success = !!(civicrm_id = (table == "donations" ? sync_donation_from_fgdb(fgdb_id) : sync_contact_from_fgdb(fgdb_id)))
    else #source == "civicrm"
      civicrm_id = tid
      success = !!(fgdb_id = (table == "donations" ? sync_donation_from_civicrm(civicrm_id) : sync_contact_from_civicrm(civicrm_id)))
    end
  end

  if success
    system(ENV["SCRIPT"], "rm", source, table, tid)
    if source == "civicrm"
      system(ENV["SCRIPT"], "rm", "fgdb", table, fgdb_id)
    else # source == "fgdb"
      system(ENV["SCRIPT"], "add", "skip_civicrm", table, civicrm_id)
    end
  end
end

if $0 == __FILE__
  do_main
end

