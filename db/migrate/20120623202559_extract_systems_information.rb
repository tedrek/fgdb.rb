class ExtractSystemsInformation < ActiveRecord::Migration
  def self.up
    for i in [:l1_cache_total, :l2_cache_total, :l3_cache_total, :processor_slot, :processor_product, :processor_speed, :north_bridge]
      add_column :systems, i, :string
    end
    for i in [:sixty_four_bit, :virtualization]
      add_column :systems, i, :boolean
    end
    add_column :systems, :last_build, :date
  end

  def self.down
    for i in [:l1_cache_total, :l2_cache_total, :l3_cache_total, :processor_slot, :processor_product, :processor_speed, :north_bridge]
      remove_column :systems, i
    end
    for i in [:sixty_four_bit, :virtualization]
      remove_column :systems, i
    end
    remove_column :systems, :last_build
  end
end
