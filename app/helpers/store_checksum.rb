class StoreChecksumException < Exception
end

class BaseStore
  def self.new_from_base10(val)
    BaseStore.new(:base10 => val)
  end

  def self.new_from_base_store(val)
    BaseStore.new(:base_store => val)
  end

  def initialize(h)
    @base_store = h[:base_store]
    @base10 = h[:base10]
  end

  def base_store
    @base_store ||= _base_store
  end

  def base10
    @base10 ||= _base10
  end

  def _base_store
    number = @base10.to_i
    ret = ''
    while(number != 0)
      ret = _char_arr[number % _char_arr.length] + ret
      number = number / _char_arr.length
    end
    return ret
  end

  def _base10
    ret = 0
    @base_store.split(//).each{|digit|
      char = _char_arr.index(digit.upcase)
      raise StoreChecksumException if char.nil?
      ret = (char + ret) * _char_arr.length
    }
   return (ret/_char_arr.length).to_s
  end

  private

  def _char_arr
    @char_arr ||= Default["checksum_base"].split(//)
  end
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
    if Default.is_pdx
      @checksum = @checksum.gsub(/l/, 'i')
      @checksum = @checksum.gsub(/1/, 'i')
    end
    arr = BaseStore.new_from_base_store(@checksum).base10.to_i
    @checkbit = (arr % 100)
    hex = ((arr - @checkbit) / 100.0) - 1000
    result = hex.to_i.to_s
    raise StoreChecksumException if checkbit != self.class.new_from_result(result).checkbit
    return result
  end

  def _checksum
    hex = ((1000 + @result.to_i) * 100)
    @checkbit = ((10000000000000000000000000000*(@result.to_i + extra_data)).to_s(2).scan(/./).inject(0){|t,x| t+=x.to_i} % 100)
    hex += @checkbit
    hex = BaseStore.new_from_base10(hex).base_store
    return hex
  end
end
