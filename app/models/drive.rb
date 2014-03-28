class Drive < ActiveRecord::Base
  has_many :runs
  has_many :checks, through: :runs

  def self.create_generic(opts)
    if opts[:size].nil?
      raise StandardError.new("Unable to create generic drive without size")
    end

    new(manufacturer: 'Unknown',
        model: 'Unknown',
        serial: 'Unknown',
        size: opts[:size])
  end
end
