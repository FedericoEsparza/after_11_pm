require './helpers/objectify_utilities'
require './helpers/latex'

include ObjectifyUtilities
include Latex

class String
  def base_latex
    self
  end

  def copy
    self
  end

  def greater?(exp)
    if exp.is_a?(String)
      self < exp
    elsif exp.is_a?(Numeric) || exp.is_a?(fraction)
      true
    else
      self.greater?(exp.args.first)
    end
  end

  def contains?(subject)
    self == subject
  end

  def sort_elements
    self
  end

  def flatit
    self
  end

  def shorten
    gsub!('\\left','')
    gsub!('\\right','')
    gsub!('\\displaystyle','')
    self
  end

  def correct_latex?
    objectify.latex.shorten == self
  end

  def expand
    [self]
  end

  def objectify
    original_string = self.dup
    # original_string.gsub!(' ','')
    i = 1
    while i < original_string.length
      if insert_plus?(original_string,i)
        original_string.insert(i,'+')
        i += 1
      end
      i += 1
    end
    original_string.original_objectify
  end

  def insert_plus?(original_string,i)
    #regex would be nice...
    original_string[i] == '-' && original_string[i-1] != '{' &&
    original_string[i-1] != '(' && original_string[i-1] != '+' &&
    original_string[i-1] != '-' && original_string[i+1] != '-'
  end

  def original_objectify
    # should refactor to the following lines inbetween *'s
    # ****************************************************
    # original_string = self.dup
    # structure_str = empty_brackets(original_string.dup)
    # args = structure_str.outer_function_args(original_string)
    # return structure_str.outer_function_class.new(args)
    # ****************************************************

    original_string = self.dup
    structure_str = empty_brackets(original_string.dup)

    if structure_str._outer_func_is_add?
      args = structure_str._add_args(original_string)
      object_args = args.inject([]){ |r,e| r << e.original_objectify }
      return add(object_args)
    end

    if structure_str._outer_func_is_sbt?
      args = structure_str._sbt_args(original_string)
      object_args = args.inject([]){ |r,e| r << e.original_objectify }
      return sbt(object_args)
    end

    if structure_str._outer_func_is_mtp?
      args = structure_str._mtp_args(original_string)
      object_args = args.inject([]){ |r,e| r << e.original_objectify }
      return mtp(object_args)
    end

    if structure_str._outer_func_is_div?
      args = structure_str._div_args(original_string)
      object_args = args.inject([]){ |r,e| r << e.original_objectify }
      return div(object_args)
    end

    if structure_str._outer_func_is_pow?
      args = structure_str._pow_args(original_string)
      object_args = args.inject([]){ |r,e| r << e.original_objectify }
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

    if structure_str._outer_func_is_eqn?
      args = structure_str._eqn_args(original_string)
      object_args = args.inject([]){ |r,e| r << e.original_objectify }
      return eqn(object_args[0],object_args[1])
    end

    if structure_str._outer_func_is_sin?
      args = structure_str._sin_cos_tan_args(original_string)
      object_args = args.inject([]){ |r,e| r << e.original_objectify }
      return sin(object_args)
    end

    if structure_str._outer_func_is_cos?
      args = structure_str._sin_cos_tan_args(original_string)
      object_args = args.inject([]){ |r,e| r << e.original_objectify }
      return cos(object_args)
    end

    if structure_str._outer_func_is_tan?
      args = structure_str._sin_cos_tan_args(original_string)
      object_args = args.inject([]){ |r,e| r << e.original_objectify }
      return tan(object_args)
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
    str_args = split_mtp_args(self)
    reenter_str_content(original_string,str_args)
    remove_enclosing_bracks(str_args)
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
    each_char.with_index { |c,i| pow_index = i if c == '^' }
    args = [original_string[0..pow_index-1],original_string[pow_index+1..-1]]
    remove_enclosing_bracks(args)
    args
  end

  def _eqn_args(original_string)
    equal_i = original_string.index('=')
    args = []
    args << original_string.slice(0..equal_i-1)
    args << original_string.slice(equal_i+1..-1)
    args
  end

  def _outer_func_is_add?
    return false if include?('+') == false || include?('=')
    for i in 1..(length-1)
      return false if self[-i] == '-' && self[-(i+1)] != '+'
      return true if self[-i] == '+'
    end
    return false
  end

  def _outer_func_is_sbt?
    return false if include?('-') == false || include?('=')
    for i in 1..(length-1)
      return true if self[-i] == '-' && self[-(i+1)] != '+'
    end
    return false
  end

  def _outer_func_is_mtp?
    return false if self == '-'
    return false if self[1..(length-1)] =~ /\+|\-|\=/
    return false if split_mtp_args(dup).length == 1
    return false if self =~ /^\\sin/
    return true
    # !((self == '-') || (self[1..(length-1)] =~ /\+|\-|\=/) ||
      # (split_mtp_args(dup).length == 1))
  end

  def _outer_func_is_div?
    # return false if self =~ /\=/
    # return false if self[1..(length-1)] =~ /\+|\-/
    # return false if split_mtp_args(dup).length > 1
    # return true if self =~ /^\\frac/
    # return false
    # !!((!(self =~ /\=/) && !(self[1..(length-1)] =~ /\+|\-/) && !(split_mtp_args(dup).length > 1)) && (self =~ /^\\frac/))
    __not_eqn? && __not_plus_or_minus? &&
     __not_more_than_one_mtp_args? && __starts_with_frac?

  end

  def __not_eqn?
    !(self =~ /\=/)
  end

  def __not_plus_or_minus?
    !(self[1..(length-1)] =~ /\+|\-/)
  end

  def __not_more_than_one_mtp_args?
    !(split_mtp_args(dup).length > 1)
  end

  def __starts_with_frac?
    !!(self =~ /^\\frac/)
  end

  def _outer_func_is_pow?
    return false unless self =~ /\^/
    copy = self.dup
    power_part = copy.slice(/((\d+)|(\(\$*\))|([A-Za-z]))\^(([A-Za-z])|(\{\$*\})|(\d))/)
    power_part == self
  end

  def _sin_cos_tan_args(original_string)
    original_string.slice!(0..3)
    original_string.gsub!(' ','')
    args = [original_string]
    remove_enclosing_bracks(args)
    args
  end

  def _outer_func_is_sin?
    !!(self =~ /^\\sin/)
  end

  def _outer_func_is_cos?
    !!(self =~ /^\\cos/)
  end

  def _outer_func_is_tan?
    !!(self =~ /^\\tan/)
  end

  def _outer_func_is_eqn?
    !!(self =~ /\=/)
  end

  def _is_numeral?
    self.to_i.to_s == self
  end

  def _is_string_var?
    !!(self =~ /[A-Za-z]/) && length == 1
  end

  def find_vars
    [self]
  end

  def subs_terms(old_var,new_var)
    if self == old_var
      return new_var
    else
      self
    end
  end

end
