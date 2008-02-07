module TransactionHelper

  class Column
    def initialize(klass, opts)
      raise "bad constructor: needs a name" unless opts.has_key? :name
      @klass = klass
      @opts = opts
    end

    def eval
      @opts[:eval] || "#{Inflector.underscore(klass)}.#{@opts[:name]}"
    end

    def name
      @opts[:name]
    end

    def class_name
      @klass.to_s
    end

    def sanitize?
      true
    end
  end

  def num_columns(context)
    scaffold_columns(context).length + 1
  end

  def scaffold_columns(context)
    case context
    when 'sale'
      [
       Column.new(Sale, :name => 'id', :eval => 'sale.id'),
       Column.new(Sale, :name => 'payment',
                                        :eval => 'sale.payment', :sortable => false),
       Column.new(Sale, :name => 'buyer', :sortable => false, :eval => 'sale.buyer'),
       Column.new(Sale, :name => 'created_at', :eval => 'sale.created_at'),
      ]
    when 'donation'
      [
       Column.new(Donation, :name => 'id'),
       Column.new(Donation, :name => 'payment',
                                        :eval  => 'donation.payment', :sortable => false),
       Column.new(Donation, :name => 'donor', :sortable => false),
       Column.new(Donation, :name => 'created_at'),
      ]
    when 'disbursement'
      [
       Column.new(Disbursement, :name => 'id'),
       Column.new(Disbursement, :name => 'disbursement_type', :sortable => false),
       Column.new(Disbursement, :name => 'recipient', :sortable => false),
       Column.new(Disbursement, :name => 'gizmos', :sortable => false),
       Column.new(Disbursement, :name => 'disbursed_at'),
      ]
    when 'recycling'
      [
       Column.new(Recycling, :name => 'gizmos', :sortable => false),
       Column.new(Recycling, :name => 'recycled_at'),
      ]
    end
  end

  def contact_searchbox_id(options)
    "#{options[:scaffold_id]}_contact_searchbox"
  end

  def totals_id(context)
    context + "_totals_div"
  end
end
