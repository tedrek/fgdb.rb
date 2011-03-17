class StoreChecksumException < Exception
end

class StoreChecksum
  # takes a decimal ID in
  # adds the id with the amount_cents of the store credit, looks at
  #  the sums binary and counts the 1's. takes the last digit of the
  #  decimal count and that is our checkbit.
  # multiplies the ID by 10 and adds the checkbit to it, then convers
  #  this new number to hex, that's out hash
  def self.new_from_result(val)
    new({:result => val})
  end

  # takes this hexadecimal hash in
  # converts it to its decimal form
  # takes the last decimal digit off, that's the "checkbit"
  # the remaining part is the actual ID, it's sent back through this
  # class to make sure its checkbit is correct.
  def self.new_from_checksum(val)
    new({:checksum => val})
  end

  def initialize(hash)
    @checksum = hash[:checksum]
    @result = hash[:result]
    @checksum = @checksum.to_s.downcase if @checksum
    @result = @result.to_s if @result
    @checkbit = nil
  end

  def extra_data # so much for a class interface..
    s = StoreCredit.find_by_id(result.to_i)
    raise StoreChecksumException if !s
    return s.amount_cents
  end

  def checksum
    @checksum ||= _checksum
  end

  def result
    @result||= _result
  end

  def checkbit
    @checkbit ||= _checkbit
  end

  def _checkbit
    result
    checksum
    @checkbit
  end

  def _result
    arr = @checksum.to_i(16).to_s(10).scan(/./)
    @checkbit = arr.pop
    hex = arr.join("")
    result = hex
    raise StoreChecksumException if checkbit != self.class.new_from_result(result).checkbit
    return result
  end

  def _checksum
    hex = @result.to_s
    @checkbit = (@result.to_i + extra_data).to_s(2).scan(/./).inject(0){|t,x| t+=x.to_i}.to_s(10).scan(/./).last
    hex += @checkbit
    hex = hex.to_i.to_s(16)
    return hex
  end
end
