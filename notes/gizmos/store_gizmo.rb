class StoreGizmo < Gizmo
  # some intended to be overridden
  # much of this is illegal or pseudo code

  def self.add(bucket, count, *args)
    bucket ||= StoreGizmo::Tally.new
    super(bucket, count, *args)
  end

  def self.subtract(bucket, count, *args)
    bucket ||= StoreGizmo::Tally.new
    super(bucket, count, *args)
  end

  def self.update_receipts(bucket, amount, *args)
    bucket ||= StoreGizmo::Receipts.new
  end

  def self.update_discounts(bucket, amount, *args)
    bucket ||= StoreGizmo::Discounts.new
  end

  class Receipts
    # accesses some field in store?? tallies table
    # ?knows how to report receipts for specific gizmo types?
    def add(amount)
      # get my tallies.store_gizmo_amount
      # add to it, then store it
    end

    def subtract(amount)
      add(-amount)
      # maybe update some refunds, inventory buckets, too
    end
  end

  class Discounts
    # probably has lot in common with Receipts methods

    # keeping class separate for now in anticipation of
    # divergent future uses, mostly reporting
  end

  class Tally
    # accesses some field in store?? tallies table
    # otherwise feels v similar to Receipts methodwise
    def add(amount)
      # get my tallies.store_gizmo_counter
        # probably needs to be overridden on per-item-type basis
      # add to it, then store it
      # maybe update some inventory bucket, too
    end
  end

end
