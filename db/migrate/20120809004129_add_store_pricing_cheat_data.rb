class AddStorePricingCheatData < ActiveRecord::Migration
  def self.up
    types = {}

    pt = PricingType.new
    pt.name = "Intel"
    pt.pull_from = "processor_product"
    pt.matcher = "Intel"
    pt.base_value_cents = 0
    pt.multiplier_cents = 92
    pt.round_by_cents = 500
    pt.gizmo_type = GizmoType.find_by_name('system')
    types[:intel] = pt
    pt.save!

    pt = PricingType.new
    pt.name = "Intel Laptop"
    pt.pull_from = "processor_product"
    pt.matcher = "Intel"
    pt.types = [Type.find_by_name("laptop")]
    pt.base_value_cents = 7000
    pt.multiplier_cents = 85
    pt.round_by_cents = 500
    pt.gizmo_type = GizmoType.find_by_name('laptop')
    types[:intel_laptop] = pt
    pt.save!

    pt = PricingType.new
    pt.name = "AMD"
    pt.pull_from = "processor_product"
    pt.matcher = "AMD"
    pt.base_value_cents = 0
    pt.multiplier_cents = 93
    pt.round_by_cents = 500
    pt.gizmo_type = GizmoType.find_by_name('system')
    types[:amd] = pt
    pt.save!

    pt = PricingType.new
    pt.name = "AMD Laptop"
    pt.pull_from = "processor_product"
    pt.matcher = "AMD"
    pt.types = [Type.find_by_name("laptop")]
    pt.base_value_cents = 7000
    pt.multiplier_cents = 90
    pt.round_by_cents = 500
    pt.gizmo_type = GizmoType.find_by_name('laptop')
    types[:amd_laptop] = pt
    pt.save!

    pt = PricingType.new
    pt.name = "Mac"
    pt.types = [Type.find_by_name("apple"), Type.find_by_name("apple_laptop")]
    pt.base_value_cents = 0
    pt.multiplier_cents = 87
    pt.round_by_cents = 500
    pt.gizmo_type = GizmoType.find_by_name('system_mac')
    types[:mac] = pt
    pt.save!

    pt = PricingType.new
    pt.name = "Mac As-Is"
    pt.base_value_cents = 0
    pt.multiplier_cents = 150
    pt.round_by_cents = 500
    pt.gizmo_type = GizmoType.find_by_name('system_mac_as_is')
    types[:mac_as_is] = pt
    pt.save!

    list = []
    names = {}
    pulls = {}
    values = {}
    members = {}

    list << :mac_model
    names[:mac_model] = "Model"
    members[:mac_model] = [:mac]
    values[:mac_model] = [["Intel-imac-LCD (new-silver)",22000],
                          ["Intel-imac-LCD (old-White)",12500],
                          ["Intel-Mac Book",16000],
                          ["Intel-Mac Book Pro(new)",28000],
                          ["Intel-Mac Book Pro(old)",17000],
                          ["Intel-Mac Mini",7000],
                          ["Intel-MacPro Tower",22000],
                          ["PPC-ibook",1500],
                          ["PPC-imac(lcd)",4500],
                          ["PPC-imac(sunFlower Type)",-4500],
                          ["PPC-Mac Mini",4500],
                          ["PPC-Power Book",3000],
                          ["PPC-Power Mac(G4 type)",1000],
                          ["PPC-Power Mac(G5 type)",5000]]

    list << :mac_as_is_model
    names[:mac_as_is_model] = "Model"
    members[:mac_as_is_model] = [:mac_as_is]
    values[:mac_as_is_model] = [["Intel-imac-LCD",3000],
                                ["Intel-Mac Book",1000],
                                ["Intel-Mac Book Pro",1500],
                                ["Intel-Mac Pro(Tower)",5000],
                                ["PPC-iLamp(sunflower)",2000],
                                ["PPC-imac(lcd)",3000],
                                ["PPC-Power Book",500],
                                ["PPC-Power Mac(G4 type)",1000],
                                ["PPC-Power Mac(G5 type)",3500]]

    list << :mac_cpu
    names[:mac_cpu] = "CPU"
    pulls[:mac_cpu] = "processor_product"
    members[:mac_cpu] = [:mac]
    values[:mac_cpu] = [["G4",500],
                        ["G4-Dual",2000],
                        ["G5",3500],
                        ["G5-Dual",5500],
                        ["G5-Quad",10000],
                        ["Intel-Core 2 Duo",11700],
                        ["Intel-Core Duo",8500],
                        ["Intel-Core Solo",7500],
                        ["Intel-i5",16300],
                        ["Intel-i7",21000],
                        ["Intel-Xeon",18000],
                        ["Intel-Xeon Dual",17000],
                        ["Intel-Xeon Octo",30000],
                        ["intel-Xeon Quad",20000]]

    list << :mac_as_is_cpu
    names[:mac_as_is_cpu] = "CPU"
    pulls[:mac_as_is_cpu] = "processor_product"
    members[:mac_as_is_cpu] = [:mac_as_is]
    values[:mac_as_is_cpu] = [["G4",1000],
                              ["G4-Dual",1000],
                              ["G5",2000],
                              ["G5-Dual",4000],
                              ["G5-Quad Core",5500],
                              ["Intel-Core 2 Duo",2500],
                              ["Intel-Core Duo",2000],
                              ["Intel-Core Solo",1000],
                              ["Intel-i5",5000],
                              ["Intel-i7",10000],
                              ["Intel-Xeon",8000],
                              ["intel-Xeon Quad",12000]]

    list << :cpu
    names[:cpu] = "CPU"
    pulls[:cpu] = "processor_product"
    members[:cpu] = [:intel, :intel_laptop]
    values[:cpu] = [["Core i7", 17500],
                    ["Core i5", 11500],
                    ["Core 2 Quad", 8000],
                    ["Core 2 Duo", 6000],
                    ["Core Duo", 4000],
                    ["Core i3", 3500],
                    ["Pentium Dual-Core", 2700],
                    ["Pentium M", 1800],
                    ["Pentium D", 1700],
                    ["Atom", 1500],
                    ["Core Solo", 1500],
                    ["Celeron M", 1500],
                    ["Pentium 4", 1400],
                    ["Celeron D", 1000],
                    ["Celeron", 800]]

    list << :cpu_amd
    names[:cpu_amd] = "CPU"
    pulls[:cpu_amd] = "processor_product"
    members[:cpu_amd] = [:amd, :amd_laptop]
    values[:cpu_amd] = [["Athlon 64",2500],
                        ["Athlon 64 x2",6000],
                        ["Athlon 64 x4",8000],
                        ["Phenom x2",7000],
                        ["Phenom x4",9500],
                        ["Phenom x6",11500],
                        ["Sempron",1300],
                        ["Turion",2500],
                        ["Turion Mobile",3500],
                        ["Turion 64 x2",5500]]

    list << :clock_speed
    names[:clock_speed] = "Clock Speed"
    pulls[:clock_speed] = "processor_speed"
    members[:clock_speed] = [:intel, :intel_laptop]
    values[:clock_speed] = [["3.80ghz", 3500],
                            ["3.60ghz", 3000],
                            ["3.40ghz", 2800],
                            ["3.20ghz", 2700],
                            ["3.06ghz", 2600],
                            ["3.00ghz", 2500],
                            ["2.93ghz", 2200],
                            ["2.80ghz", 2000],
                            ["2.66ghz", 1900],
                            ["2.53ghz", 1800],
                            ["2.50ghz", 1700],
                            ["2.40ghz", 1600],
                            ["2.33ghz", 1500],
                            ["2.26ghz", 1400],
                            ["2.20ghz", 1300],
                            ["2.16ghz", 1200],
                            ["2.13ghz", 1000],
                            ["2.10ghz", 900],
                            ["2.00ghz", 800],
                            ["1.86ghz", 700],
                            ["1.80ghz", 600],
                            ["1.72ghz", 500],
                            ["1.70ghz", 400],
                            ["1.60ghz", 300],
                            ["1.40ghz", 200],
                            ["1.20ghz", 100]]

    list << :amd_clock_speed
    names[:amd_clock_speed] = "Clock Speed"
    pulls[:amd_clock_speed] = "processor_speed"
    members[:amd_clock_speed] = [:amd, :amd_laptop]
    values[:amd_clock_speed] = [["1.60ghz",1000],
                                ["1.70ghz",1100],
                                ["1.80ghz",1200],
                                ["1.90ghz",1300],
                                ["2.00ghz",1400],
                                ["2.10ghz",1500],
                                ["2.20ghz",1600],
                                ["2.30ghz",1700],
                                ["2.40ghz",1800],
                                ["2.50ghz",1900],
                                ["2.60ghz",2000],
                                ["2.70ghz",2100],
                                ["2.80ghz",2200],
                                ["2.90ghz",2300],
                                ["3.00ghz",2400],
                                ["3.10ghz",2500],
                                ["3.20ghz",2600],
                                ["3.30ghz",2700],
                                ["3.40ghz",2800],
                                ["3.60ghz",2900]]

    list << :mac_clock_speed
    names[:mac_clock_speed] = "Clock Speed"
    pulls[:mac_clock_speed] = "processor_speed"
    members[:mac_clock_speed] = [:mac]
    values[:mac_clock_speed] = [["1.42ghz",1500],
                                ["1.50ghz",1600],
                                ["1.67ghz",1800],
                                ["1.60ghz",1700],
                                ["1.80ghz",2000],
                                ["2.00ghz",2500],
                                ["2.20ghz",3100],
                                ["2.30ghz",3200],
                                ["2.40ghz",3500],
                                ["2.60ghz",3500],
                                ["2.80ghz",4000],
                                ["3.00ghz",4500],
                                ["3.20ghz",5500],
                                ["3.40ghz",6000]]

    list << :"l2/l3_cache"
    members[:"l2/l3_cache"] = [:intel, :intel_laptop, :amd, :amd_laptop]
    names[:"l2/l3_cache"] = "L2/L3 Cache"
    pulls[:"l2/l3_cache"] = "max_l2_l3_cache"
    values[:"l2/l3_cache"] = [["8mb", 11500],
                              ["12mb", 10000],
                              ["6mb", 7500],
                              ["4mb", 5500],
                              ["3mb", 4500],
                              ["2mb", 3800],
                              ["1mb", 1800],
                              ["512k", 1400],
                              ["256k", 900],
                              ["128k", 500]]
    list << :ram_size
    names[:ram_size] = "RAM Size"
    members[:ram_size] = [:intel, :intel_laptop, :amd, :amd_laptop, :mac]
    pulls[:ram_size] = "memory_amount"
    values[:ram_size] = [["8.0 gb", 12000],
                         ["6.0 gb", 7800],
                         ["4.0 gb", 5800],
                         ["3.0 gb", 4200],
                         ["2.5 gb", 3300],
                         ["2.0 gb", 2800],
                         ["1.5 gb", 2300],
                         ["1.2 gb", 1800],
                         ["1.0 gb", 1300],
                         ["768 mb", 900],
                         ["512 mb", 400]]
    list << :hd_size
    members[:hd_size] = [:intel, :intel_laptop, :amd, :amd_laptop, :mac]
    names[:hd_size] = "HD Size"
    pulls[:hd_size] = "hd_size"
    values[:hd_size] = [["2TB", 9000],
                        ["1.5TB", 8500],
                        ["1TB", 8000],
                        ["900gb", 7500],
                        ["800gb", 7000],
                        ["750gb", 6000],
                        ["600gb", 5500],
                        ["500gb", 5000],
                        ["450gb", 4500],
                        ["400gb", 4500],
                        ["380gb", 4200],
                        ["360gb", 4000],
                        ["250gb", 3900],
                        ["350gb", 3800],
                        ["340gb", 3800],
                        ["300gb", 3500],
                        ["320gb", 3500],
                        ["280gb", 3200],
                        ["260gb", 3000],
                        ["240gb", 3000],
                        ["220gb", 2700],
                        ["200gb", 2500],
                        ["180gb", 2000],
                        ["160gb", 2000],
                        ["130gb", 1500],
                        ["140gb", 1500],
                        ["100gb", 1200],
                        ["120gb", 1200],
                        ["80gb", 900],
                        ["60gb", 600],
                        ["50gb", 400],
                        ["40gb", 200],
                        ["30gb", 0]]
    list << :optical_drive
    members[:optical_drive] = [:intel, :intel_laptop, :amd, :amd_laptop, :mac]
    names[:optical_drive] = "Optical Drive"
    pulls[:optical_drive] = "optical_drive"
    values[:optical_drive] = [["DVD/RW", 1500],
                              ["Combo  DVD CD/RW", 500],
                              ["DVD Rom", 500],
                              ["CD Rom", 0],
                              ["CD/RW", 0],
                              ["N/A", 0]]

    list << :battery
    members[:battery] = [:intel_laptop, :amd_laptop]
    names[:battery] = "Battery Life"
    pulls[:battery] = "battery_life"
    values[:battery] = [["1 to 29 minutes",-2500],
["121 to 149 minutes",2000],
["150 to 170 minutes",3000],
["171 to 200 minutes",3500],
["201 to 230 minutes",4000],
["231 to 260 minutes",4500],
["261 to 300 minutes",5000],
["30 to 60 minutes",500],
["301 to 350 minutes",5500],
["351 to 500 minutes",7000],
["61 to 90 minutes",1000],
["91 to 120 minutes",1500],
["Dead",-2500],
["N/A",0]]

    list << :mac_battery
    members[:mac_battery] = [:mac]
    names[:mac_battery] = "Battery Life"
    values[:mac_battery] = [["N/A (Laptops Only)",0],
                            ["Dead",-3000],
                            ["Under 25% ",500],
                            ["26% to 46%",1500],
                            ["47% to 69%",2000],
                            ["70% to 86%",3000],
                            ["87% to 100%",4500]]

    list << :pros
    members[:pros] = [:intel_laptop, :amd_laptop, :mac]
    names[:pros] = "Pros"
    values[:pros] = [["Bluetooth",500],
["Card Reader",500],
["Glossy Screen",1000],
["Large Screen",1000],
["Tiny Screen",500],
["Webcam",500]]

    list << :cons
    members[:cons] = [:intel_laptop, :amd_laptop, :mac]
    names[:cons] = "Cons"
    values[:cons] = [["Bad Hinge",-1500],
["Finicky Keyboard",-500],
["No Optical",-500],
["Obvious Blemish",-500],
["Scratched Screen",-1000],
["Surface Cracks",-500]]

    list << :mac_as_is_pros
    members[:mac_as_is_pros] = [:mac_as_is]
    names[:mac_as_is_pros] = "Pros"
    values[:mac_as_is_pros] = [["Large Screen",2000],
["Under specs",1000],
["Works ok, Falls in the Bad Caps List",2000]]

    list << :mac_as_is_cons
    members[:mac_as_is_cons] = [:mac_as_is]
    names[:mac_as_is_cons] = "Cons"
    values[:mac_as_is_cons] = [["Bad GPU",-15],
["Bad Logicboard",-1500],
["Blown Capacitors",-1000],
["Doesn't turn on, Parts Only",-1000],
["Power supply is dead",-1500],
["Turns on Randomly",-1000]]

    list.each do |pc_n|
      pc = PricingComponent.new
      pc.name = names[pc_n]
      pc.pull_from = pulls[pc_n]
      pc.pricing_types = members[pc_n].map{|x| types[x]}
      if [:battery].include?(pc_n)
        pc.numerical = true
      end
      if [:pros, :cons, :mac_as_is_pros, :mac_as_is_cons].include?(pc_n)
        pc.multiple = true
      end
      pc.save!

      values[pc_n].each do |record|
        pv = PricingValue.new
        pv.name = record.first
        if [:battery].include?(pc_n)
          if a = record.first.match(/([0-9]+) to ([0-9]+) minutes/)
            pv.minimum = a[1]
            pv.maximum = a[2]
          else
            if record.first.match(/Dead/)
              pv.maximum = 0
              pv.minimum = 0
            end
          end
        end
        pv.value_cents = record.last
        pv.pricing_component = pc
        pv.save!
      end
    end
  end

  def self.down
    SystemPricing.destroy_all
    PricingValue.destroy_all
    PricingComponent.destroy_all
    PricingType.destroy_all
  end
end
