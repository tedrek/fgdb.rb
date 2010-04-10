module ByteFloatWrapper
  def my_float
    @my_float ||= self.to_f
  end

  def forward_to_float(*args)
    self.my_float.send(caller(0)[0].match(/^.+ `(.+)'$/)[1].to_sym, *args)
  end

  alias :to_bytes :forward_to_float
  alias :to_hertz :forward_to_float
  alias :to_bitspersecond :forward_to_float
end

class String
  include ByteFloatWrapper
end

class Fixnum
  include ByteFloatWrapper
end

class Float
  def to_bytes(precision = 0, exact = true, truncate = true, yikes_until = "G")
    name, div = find_unit(exact)
    val = nil
    if !gte(name, yikes_until)
      precision = 0
      truncate = false
    end
    val = yikes(div, precision, truncate)
    ret = val + name + "B"
  end

  def to_bitspersecond
    name, div = find_unit(false, "M")
    val = yikes(div, 0, false)
    ret = val + name + "bps"
  end

  def to_hertz
    name, div = find_unit
    val = nil
    if gte(name, "G")
      val = yikes(div, 2)
    else
      val = yikes(div, 0, false)
    end
    ret = val + name + "Hz"
  end

  #######
  private
  #######

  def unit_arr
    a = ["", "K", "M", "G", "T", "P", "E", "Z", "Y"]
  end

  def gte(v, l)
    a = unit_arr
    hit_g = false
    for x in a
      if x == l
        hit_g = true
      end
      if x == v
        return hit_g
      end
    end
    raise ArgumentError
  end

  def find_unit(exact = false, base = "")
    a = unit_arr
    base_div = exact ? 1024 : 1000
    start_i = -1
    i = 0
    for x in a
      if x == base
        start_i = i
        break
      end
      i += 1
    end
    if start_i == -1
      raise ArgumentError
    end
    number = self * (base_div ** start_i)
    i = 0
    final_i = -1
    for x in a
      n = number / (base_div ** i)
      if n < 1.0
        final_i = i - 1
        break
      end
      i += 1
    end
    if final_i == -1
      final_i = 0
    end
    found_name = a[final_i]
    found_divisor = base_div ** (final_i - start_i)
    return [found_name, found_divisor]
  end

  def yikes(divide_by, precision = 0, truncate = true)
    f = nil
    if truncate
      f = ((((self/divide_by)*(10**precision)).to_i).to_f)/(10**precision)
    else
      f = self / divide_by
    end
    return sprintf("%.#{precision}f", f)
  end
end
