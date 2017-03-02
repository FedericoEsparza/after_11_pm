require './helpers/objectify_utilities'

include ObjectifyUtilities

class String
  def latex
    self
  end


  def greater?(exp)
    if exp.is_a?(String)
      self < exp
    elsif exp.is_a?(Numeric)
      true
    else
      self.greater?(exp.args.first)
    end
  end

  def sort_elements
    self
  end

  def shorten
    gsub!('\\left','')
    gsub!('\\right','')
    gsub!('\\displaystyle','')
    self
  end

  def correct_latex?
    objectify(self).latex.shorten == self
  end

  def expand
    [self]
  end

  def new_objectify
    original_string = self.dup
    original_string.gsub!(' ','')

    i = 1
    while i < original_string.length && i < 200
      if original_string[i] == '-' && original_string[i-1] != '{' && original_string[i-1] != '(' && original_string[i-1] != '+' && original_string[i-1] != '-' && original_string[i+1] != '-'
        original_string.insert(i,'+')
        i += 2
      end
      i += 1
    end


    # original_string.gsub!('-','+-')
    # if original_string[0] == '+'
    #   original_string.slice!(0)
    # end
    # puts '=========='
    # p original_string
    # puts '=========='
    original_string.objectify
  end


  def objectify
    original_string = self.dup
    original_string.gsub!(' ','')
    # original_string.gsub!('-','+-')
    structure_str = empty_brackets(original_string.dup)

    if structure_str._outer_func_is_add?
      args = structure_str._add_args(original_string)
      object_args = args.inject([]){ |r,e| r << e.objectify }
      return add(object_args)
    end

    if structure_str._outer_func_is_sbt?
      args = structure_str._sbt_args(original_string)
      object_args = args.inject([]){ |r,e| r << e.objectify }
      return sbt(object_args)
    end

    if structure_str._outer_func_is_mtp?
      args = structure_str._mtp_args(original_string)
      object_args = args.inject([]){ |r,e| r << e.objectify }
      return mtp(object_args)
    end

    if structure_str._outer_func_is_div?
      args = structure_str._div_args(original_string)
      object_args = args.inject([]){ |r,e| r << e.objectify }
      return div(object_args)
    end

    if structure_str._outer_func_is_pow?
      args = structure_str._pow_args(original_string)
      object_args = args.inject([]){ |r,e| r << e.objectify }
      return pow(object_args)
    end

    if structure_str._is_string_var?
      return self
    end

    if structure_str._is_numeral?
      return self.to_i
    end

    if structure_str == '-'
      return -1
    end
  end

  def _add_args(original_string)
    plus_indices = []
    for j in 1..length
      plus_indices.insert(0,length - j) if self[-j] == '+'
      break if self[-j] == '-' && self[-(j+1)] != '+'
    end
    plus_indices.insert(0,-1)
    plus_indices << length
    slice_indices = []
    for k in 1..plus_indices.length-1
      slice_indices << [plus_indices[k-1]+1,plus_indices[k]-1]
    end
    str_args = []
    slice_indices.each {|a| str_args << self.slice(a[0]..a[1]) }
    reenter_addition_str_content(original_string,str_args)
    remove_enclosing_bracks(str_args)
    str_args
  end

  def _sbt_args(original_string)
    for i in 1..(length-1)
      if self[-i] == '-' && self[-(i+1)] != '-' && (self[-(i+1)] != '+' || i+1 == length)
        sbt_index = length - i
        break
      end
    end
    args = [slice(0..sbt_index-1),slice(sbt_index+1..-1)]
    reenter_addition_str_content(original_string,args)
    remove_enclosing_bracks(args)
    args
  end

  def _mtp_args(original_string)
    # puts '================'
    # p self
    # puts '================'
    str_args = split_mtp_args(self)
    # puts '================'
    # p str_args
    # puts '================'
    reenter_str_content(original_string,str_args)
    remove_enclosing_bracks(str_args)
    # puts '================'
    # p str_args
    # puts '================'
    str_args
  end

  def _div_args(original_string)
    top_indices = matching_brackets(original_string,'{','}')
    numerator = original_string.slice(top_indices[0]+1..top_indices[1]-1)
    original_string.slice!(0..top_indices[1])
    bot_indices = matching_brackets(original_string,'{','}')
    denominator = original_string.slice(bot_indices[0]+1..bot_indices[1]-1)
    [numerator,denominator]
  end

  def _pow_args(original_string)
    pow_index = 0
    each_char.with_index do |c,i|
      if c == '^'
        pow_index = i
      end
    end
    args = [original_string[0..pow_index-1],original_string[pow_index+1..-1]]
    remove_enclosing_bracks(args)
    args
  end

  def _outer_func_is_add?
    return false if include?('+') == false
    for i in 1..(length-1)
      return false if self[-i] == '-' && self[-(i+1)] != '+'
      return true if self[-i] == '+'
    end
    return false
  end

  def _outer_func_is_sbt?
    return false if include?('-') == false
    for i in 1..(length-1)
      return true if self[-i] == '-' && self[-(i+1)] != '+'
    end
    return false
  end

  def _outer_func_is_mtp?
    return false if self == '-'
    return false if self[1..(length-1)] =~ /\+|\-/
    return false if split_mtp_args(dup).length == 1
    return true
  end

  def _outer_func_is_div?
    return false if self[1..(length-1)] =~ /\+|\-/
    return false if split_mtp_args(dup).length > 1
    return true if self =~ /^\\frac/
    return false
  end

  def _outer_func_is_pow?
    return false if self[1..(length-1)] =~ /\+|\-/
    return false if split_mtp_args(dup).length > 1
    return true if self =~ /\^/
    return false
  end

  def _is_numeral?
    self.to_i.to_s == self
  end

  def _is_string_var?
    !!(self =~ /[A-Za-z]/) && length == 1
  end

end
