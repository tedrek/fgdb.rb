class AddStorePricingCheatData < ActiveRecord::Migration
  def self.up
    list = []
    names = {}
    pulls = {}
    values = {}

    list << :cpu
    names[:cpu] = "CPU"
    pulls[:cpu] = "processor_product"
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
    list << :clock_speed
    names[:clock_speed] = "Clock Speed"
    pulls[:clock_speed] = "processor_speed"
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
    list << :"l2/l3_cache"
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
    names[:optical_drive] = "Optical Drive"
    pulls[:optical_drive] = "optical_drive"
    values[:optical_drive] = [["DVD/RW", 1500],
                              ["Combo  DVD CD/RW", 500],
                              ["DVD Rom", 500],
                              ["CD Rom", 0],
                              ["CD/RW", 0],
                              ["N/A", 0]]

    pt = PricingType.new
    pt.name = "Intel"
    pt.pull_from = "processor_product"
    pt.matcher = "Intel"
    pt.base_value_cents = 0
    pt.multiplier_cents = 92
    pt.round_by_cents = 500
    pt.gizmo_type = GizmoType.find_by_name('system')
    pt.save!

    list.each do |pc_n|
      pc = PricingComponent.new
      pc.name = names[pc_n]
      pc.pull_from = pulls[pc_n]
      pc.pricing_types = [pt]
      pc.save!

      values[pc_n].each do |record|
        pv = PricingValue.new
        pv.name = record.first
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
