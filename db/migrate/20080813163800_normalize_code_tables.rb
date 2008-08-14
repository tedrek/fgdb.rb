class NormalizeCodeTables < ActiveRecord::Migration

  def self.normalize(con, table, codes, rename=false)
    name_col = "name"
    desc_col = "description"
    rename_column(table, name_col, desc_col) if rename
    add_column table, name_col, :string, :limit=>40
    codes.each do |desc,name|
      con.execute("UPDATE #{table}
                   SET #{name_col}='#{name}'
                   WHERE #{desc_col}='#{desc}'")
    end
    con.execute("ALTER TABLE #{table} ALTER COLUMN #{name_col} SET NOT NULL")
    add_index table, name_col, :name=> "#{table}_#{name_col}_uk", :unique=>true
  end

  def self.up
    con = Action.connection
    self.normalize(con, "actions",
                   {"quality checker" => "checker",
                     "tech support" => "tech_support",
                     "build instructor" => "instructor",
                     "builder" => "builder"},
                   true)

    self.normalize(con, "community_service_types",
                   {"school" => "school",
                     "punitive" => "punitive"})

    self.normalize(con, "contact_method_types",
                   {"phone" => "phone",
                     "email" => "email",
                     "fax" => "fax",
                     "home phone" => "home_phone",
                     "work phone" => "work_phone",
                     "home email" => "home_email",
                     "liason" => "liason",
                     "emergency phone" => "emergency_phone",
                     "cell phone" => "cell_phone",
                     "work email" => "work_email",
                     "home fax" => "home_fax",
                     "work fax" => "work_fax",
                     "ip phone" => "ip_phone"})

    self.normalize(con, "contact_types",
                   {"donor" => "donor",
                     "volunteer" => "volunteer",
                     "nonprofit" => "nonprofit",
                     "staff" => "staff",
                     "adopter" => "adopter",
                     "build" => "build",
                     "certified" => "certified",
                     "waiting" => "waiting",
                     "buyer" => "buyer",
                     "comp4kids" => "comp4kids",
                     "grantor" => "grantor",
                     "member" => "member",
                     "preferemail" => "preferemail",
                     "recycler" => "recycler",
                     "offsite" => "offsite",
                     "bulk buyer" => "bulk_buyer",
                     "dropout" => "dropout"})

    self.normalize(con, "disbursement_types",
                   {"Adoption" => "adoption",
                     "Build" => "build",
                     "Hardware Grants" => "hardware_grants",
                     "GAP" => "gap",
                     "Staff" => "staff"})

    self.normalize(con, "discount_schedules",
                   {"volunteer" => "volunteer",
                     "bulk" => "bulk",
                     "friend" => "friend",
                     "no discount" => "no_discount"},
                   true)

    self.normalize(con, "gizmo_categories",
                   {"System" => "system",
                     "Monitor" => "monitor",
                     "Printer" => "printer",
                     "Misc" => "misc"})

    self.normalize(con, "gizmo_contexts",
                   {"sale" => "sale",
                     "recycling" => "recycling",
                     "disbursement" => "disbursement",
                     "donation" => "donation"},
                   true)

    self.normalize(con, "gizmo_types",
                   {"Fax Machine" => "fax_machine",
                     "Scanner" => "scanner",
                     "Printer" => "printer",
                     "Monitor" => "monitor",
                     "CRT" => "crt",
                     "Old Data CRT" => "old_data_crt",
                     "LCD" => "lcd",
                     "System" => "system",
                     "Laptop" => "laptop",
                     "1337 lappy" => "1337_lappy",
                     "Sticker" => "sticker",
                     "T-Shirt" => "t-shirt",
                     "Old Data Gizmo" => "old_data_gizmo",
                     "Old Data Schwag" => "old_data_schwag",
                     "UPS" => "ups",
                     "VCR" => "vcr",
                     "DVD Player" => "dvd_player",
                     "Keyboard" => "keyboard",
                     "Mouse" => "mouse",
                     "Stereo System" => "stereo_system",
                     "Telephone" => "telephone",
                     "Speakers" => "speakers",
                     "Card" => "card",
                     "Video Card" => "video_card",
                     "Sound Card" => "sound_card",
                     "Case" => "case",
                     "Cable" => "cable",
                     "Tuition" => "tuition",
                     "Mac" => "mac",
                     "RAM" => "ram",
                     "Laptop parts" => "laptop_parts",
                     "Power supply" => "power_supply",
                     "Miscellaneous" => "miscellaneous",
                     "Drive" => "drive",
                     "CD Burner" => "cd_burner",
                     "Harddrive" => "harddrive",
                     "Television" => "television",
                     "Old Data System" => "old_data_system",
                     "Modem" => "modem",
                     "[root]" => "root",
                     "Schwag" => "schwag",
                     "Gizmo" => "gizmo",
                     "Service Fee" => "service_fee",
                     "Fee Discount" => "fee_discount",
                     "Sys w/ monitor" => "sys_with_monitor",
                     "Net Device" => "net_device",
                     "Gift Cert" => "gift_cert",
                   })

    self.normalize(con, "payment_methods",
                   {"cash" => "cash",
                     "check" => "check",
                     "credit" => "credit",
                     "invoice" => "invoice",
                     "coupon" => "coupon"})

    self.normalize(con, "types",
                   {"regular" => "regular",
                     "freekbox" => "freekbox",
                     "grantbox" => "grantbox",
                     "laptop" => "laptop",
                     "high end" => "high_end",
                     "infrastructure" => "infrastructure",
                     "server" => "server",
                     "miscellaneous" => "misc",
                     "apple" => "apple"},
                   true)

    self.normalize(con, "volunteer_task_types",
                   {"adoption" => "adoption",
                     "cleaning" => "cleaning",
                     "monitors" => "monitors",
                     "receiving" => "receiving",
                     "recycling" => "recycling",
                     "quality control" => "quality_control",
                     "teaching" => "teaching",
                     "massage" => "massage",
                     "slacking" => "slacking",
                     "repair" => "repair",
                     "sorting" => "sorting",
                     "admin" => "admin",
                     "computers for kids" => "computers_for_kids",
                     "education" => "education",
                     "front desk" => "front_desk",
                     "misc" => "misc",
                     "orientation" => "orientation",
                     "outreach" => "outreach",
                     "printers" => "printers",
                     "programming" => "programming",
                     "sales" => "sales",
                     "support" => "support",
                     "system administration" => "system_administration",
                     "advanced testing" => "advanced_testing",
                     "data entry" => "data_entry",
                     "enterprise" => "enterprise",
                     "laptops" => "laptops",
                     "testing" => "testing",
                     "macintosh" => "macintosh",
                     "evaluation" => "evaluation",
                     "build" => "build",
                     "build, assembly" => "assembly",
                     "[root]" => "root",
                     "program" => "program",
                     "CREAM" => "cream"})
  end

  def self.down
  end
end
class NormalizeCodeTables < ActiveRecord::Migration

  def self.normalize(con, table, codes, rename=false)
    name_col = "name"
    desc_col = "description"
    rename_column(table, name_col, desc_col) if rename
    add_column table, name_col, :string, :limit=>40
    codes.each do |desc,name|
      con.execute("UPDATE #{table}
                   SET #{name_col}='#{name}'
                   WHERE #{desc_col}='#{desc}'")
    end
    con.execute("ALTER TABLE #{table} ALTER COLUMN #{name_col} SET NOT NULL")
    add_index table, name_col, :name=> "#{table}_#{name_col}_uk", :unique=>true
  end

  def self.up
    con = Action.connection
    self.normalize(con, "actions",
                   {"quality checker" => "checker",
                     "tech support" => "tech_support",
                     "build instructor" => "instructor",
                     "builder" => "builder"},
                   true)

    self.normalize(con, "community_service_types",
                   {"school" => "school",
                     "punitive" => "punitive"})

    self.normalize(con, "contact_method_types",
                   {"phone" => "phone",
                     "email" => "email",
                     "fax" => "fax",
                     "home phone" => "home_phone",
                     "work phone" => "work_phone",
                     "home email" => "home_email",
                     "liason" => "liason",
                     "emergency phone" => "emergency_phone",
                     "cell phone" => "cell_phone",
                     "work email" => "work_email",
                     "home fax" => "home_fax",
                     "work fax" => "work_fax",
                     "ip phone" => "ip_phone"})

    self.normalize(con, "contact_types",
                   {"donor" => "donor",
                     "volunteer" => "volunteer",
                     "nonprofit" => "nonprofit",
                     "staff" => "staff",
                     "adopter" => "adopter",
                     "build" => "build",
                     "certified" => "certified",
                     "waiting" => "waiting",
                     "buyer" => "buyer",
                     "comp4kids" => "comp4kids",
                     "grantor" => "grantor",
                     "member" => "member",
                     "preferemail" => "preferemail",
                     "recycler" => "recycler",
                     "offsite" => "offsite",
                     "bulk buyer" => "bulk_buyer",
                     "dropout" => "dropout"})

    self.normalize(con, "disbursement_types",
                   {"Adoption" => "adoption",
                     "Build" => "build",
                     "Hardware Grants" => "hardware_grants",
                     "GAP" => "gap",
                     "Staff" => "staff"})

    self.normalize(con, "discount_schedules",
                   {"volunteer" => "volunteer",
                     "bulk" => "bulk",
                     "friend" => "friend",
                     "no discount" => "no_discount"},
                   true)

    self.normalize(con, "gizmo_categories",
                   {"System" => "system",
                     "Monitor" => "monitor",
                     "Printer" => "printer",
                     "Misc" => "misc"})

    self.normalize(con, "gizmo_contexts",
                   {"sale" => "sale",
                     "recycling" => "recycling",
                     "disbursement" => "disbursement",
                     "donation" => "donation"},
                   true)

    self.normalize(con, "gizmo_types",
                   {"Fax Machine" => "fax_machine",
                     "Scanner" => "scanner",
                     "Printer" => "printer",
                     "Monitor" => "monitor",
                     "CRT" => "crt",
                     "Old Data CRT" => "old_data_crt",
                     "LCD" => "lcd",
                     "System" => "system",
                     "Laptop" => "laptop",
                     "1337 lappy" => "1337_lappy",
                     "Sticker" => "sticker",
                     "T-Shirt" => "t-shirt",
                     "Old Data Gizmo" => "old_data_gizmo",
                     "Old Data Schwag" => "old_data_schwag",
                     "UPS" => "ups",
                     "VCR" => "vcr",
                     "DVD Player" => "dvd_player",
                     "Keyboard" => "keyboard",
                     "Mouse" => "mouse",
                     "Stereo System" => "stereo_system",
                     "Telephone" => "telephone",
                     "Speakers" => "speakers",
                     "Card" => "card",
                     "Video Card" => "video_card",
                     "Sound Card" => "sound_card",
                     "Case" => "case",
                     "Cable" => "cable",
                     "Tuition" => "tuition",
                     "Mac" => "mac",
                     "RAM" => "ram",
                     "Laptop parts" => "laptop_parts",
                     "Power supply" => "power_supply",
                     "Miscellaneous" => "miscellaneous",
                     "Drive" => "drive",
                     "CD Burner" => "cd_burner",
                     "Harddrive" => "harddrive",
                     "Television" => "television",
                     "Old Data System" => "old_data_system",
                     "Modem" => "modem",
                     "[root]" => "root",
                     "Schwag" => "schwag",
                     "Gizmo" => "gizmo",
                     "Service Fee" => "service_fee",
                     "Fee Discount" => "fee_discount",
                     "Sys w/ monitor" => "sys_with_monitor",
                     "Net Device" => "net_device",
                     "Gift Cert" => "gift_cert",
                   })

    self.normalize(con, "payment_methods",
                   {"cash" => "cash",
                     "check" => "check",
                     "credit" => "credit",
                     "invoice" => "invoice",
                     "coupon" => "coupon"})

    self.normalize(con, "types",
                   {"regular" => "regular",
                     "freekbox" => "freekbox",
                     "grantbox" => "grantbox",
                     "laptop" => "laptop",
                     "high end" => "high_end",
                     "infrastructure" => "infrastructure",
                     "server" => "server",
                     "miscellaneous" => "misc",
                     "apple" => "apple"},
                   true)

    self.normalize(con, "volunteer_task_types",
                   {"adoption" => "adoption",
                     "cleaning" => "cleaning",
                     "monitors" => "monitors",
                     "receiving" => "receiving",
                     "recycling" => "recycling",
                     "quality control" => "quality_control",
                     "teaching" => "teaching",
                     "massage" => "massage",
                     "slacking" => "slacking",
                     "repair" => "repair",
                     "sorting" => "sorting",
                     "admin" => "admin",
                     "computers for kids" => "computers_for_kids",
                     "education" => "education",
                     "front desk" => "front_desk",
                     "misc" => "misc",
                     "orientation" => "orientation",
                     "outreach" => "outreach",
                     "printers" => "printers",
                     "programming" => "programming",
                     "sales" => "sales",
                     "support" => "support",
                     "system administration" => "system_administration",
                     "advanced testing" => "advanced_testing",
                     "data entry" => "data_entry",
                     "enterprise" => "enterprise",
                     "laptops" => "laptops",
                     "testing" => "testing",
                     "macintosh" => "macintosh",
                     "evaluation" => "evaluation",
                     "build" => "build",
                     "build, assembly" => "assembly",
                     "[root]" => "root",
                     "program" => "program",
                     "CREAM" => "cream"})
  end

  def self.down
  end
end
