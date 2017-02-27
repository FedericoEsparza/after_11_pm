module Objectify
  def brac_types
    [['(',')'], ['{', '}'], ['[', ']']]
  end

  def objectify(str)
    original_string = str.dup
    str_copy = empty_brackets(string:str.dup)

    mtp_check_str_copy = str_copy.dup
    mtp_check_str_ary = split_mtp_args(string:mtp_check_str_copy)

    # addition
    if str_copy.include?('+')
      str_args = str_copy.split('+')
      reenter_addition_str_content(string:original_string,dollar_array:str_args)
      remove_enclosing_bracks(string_array:str_args)
      object_args = str_args.inject([]){ |r,e| r << objectify(e) }
      return add(object_args)
    end

    #multiplication
    if str_copy.include?('+') == false && mtp_check_str_ary.length > 1 # && not a fraction of legnth 1 or pwer of length 1
      str_args = split_mtp_args(string:str_copy)
      reenter_str_content(string:original_string,dollar_array:str_args)
      remove_enclosing_bracks(string_array:str_args)
      object_args = str_args.inject([]){ |r,e| r << objectify(e) }
      return mtp(object_args)
    end

    # frac/div
    if mtp_check_str_ary.length == 1 && mtp_check_str_ary[0] =~ /^\\frac/
      str_args = split_mtp_args(string:str_copy)
      reenter_str_content(string:original_string,dollar_array:str_args)
      str_copy = str_args[0]
      top_indices = matching_brackets(str_copy,'{','}')
      numerator = str_copy.slice(top_indices[0]+1..top_indices[1]-1)
      str_copy.slice!(0..top_indices[1])
      bot_indices = matching_brackets(str_copy,'{','}')
      denominator = str_copy.slice(bot_indices[0]+1..bot_indices[1]-1)
      str_args = [numerator,denominator]
      object_args = str_args.inject([]){ |r,e| r << objectify(e) }
      return div(object_args)
    end

    #power
    if mtp_check_str_ary.length == 1 && mtp_check_str_ary[0] =~ /\^/
      str_args = split_mtp_args(string:str_copy)
      reenter_str_content(string:original_string,dollar_array:str_args)
      str_copy = str_args[0]
      str_args = []
      if str_copy[0] != '('
        str_args = str_copy.split('^')
      else
        bracket_indices = matching_brackets(str_copy, brac_types[0][0], brac_types[0][1],1)
        str_args << str_copy[0..bracket_indices[1]]
        str_args << str_copy[bracket_indices[1]+2..-1]
      end
      remove_enclosing_bracks(string_array:str_args)
      object_args = str_args.inject([]){ |r,e| r << objectify(e) }
      return pow(object_args)
    end

    #string variable
    if str.length == 1 && /[A-Za-z]/ =~ str
      return str
    end

    #number
    # if str.length == 1 && /[0-9]/ =~ str
    if str =~ /(^(\d|\-)\d*)/
      return str.to_i
    end
  end

  def matching_brackets(str,left_brac,right_brac,brackets_num=1)
    n_th_lbrac_index = _find_bracket_n(str,left_brac,brackets_num)
    str_copy = str.dup.slice(n_th_lbrac_index..-1)

    left_count = 0
    right_count = 0
    right_brac_index = 0

    str_copy.each_char.with_index do |c,i|
      left_count += 1 if c == left_brac
      right_count += 1 if c == right_brac
      if left_count == right_count
        right_brac_index = i
        return [n_th_lbrac_index,n_th_lbrac_index + right_brac_index]
      end
    end
  end

  def _find_bracket_n(str,left_brac,brackets_num)
    i = 0
    num_of_left_bracs = 0
    while i < str.length && num_of_left_bracs < brackets_num
      num_of_left_bracs += 1 if str[i] == left_brac
      i += 1
    end
    n_th_lbrac_index = i - 1
  end

  def empty_brackets(string:)
    result_array = []
    (0..2).each { |i| _collect_brac_indices(string,brac_types[i],result_array) }
    result_array.each do |brackets_range|
      start_i = brackets_range[0] + 1
      end_i = brackets_range[1] - 1
      string[start_i..end_i] = '$' * string[start_i..end_i].length
    end
    string
  end

  def _collect_brac_indices(str,bracket,result_array)
    i = 1
    while i <= (str.count(bracket[0]))
      result_array << matching_brackets(str,bracket[0], bracket[1], i)
      i += 1
    end
  end

  def split_mtp_args(string:)
    string_copy = string.dup
    result_array = []
    i = 0
    while string_copy.length != 0 && i < 100
      _add_next_str_var_arg(result_array,string_copy)
      _add_next_num_arg(result_array,string_copy)
      _add_next_function_arg(result_array,string_copy)
      _add_next_pow_arg(result_array,string_copy)
      _add_next_brac_arg(result_array,string_copy)
      i += 1
    end
    result_array
  end

  def _add_next_str_var_arg(result_array,string_copy)
    str_reg = /^[A-Za-z](?!\^)/
    sliced = string_copy.slice!(str_reg)
    result_array << sliced unless sliced.nil?
  end

  def _add_next_num_arg(result_array,string_copy)
    # num_reg = /^(\d+)(?!\^)/
    # sliced = string_copy.slice!(num_reg)
    # result_array << sliced unless sliced.nil?

    next_num_ind = _next_num_index(string_copy)
    if next_num_ind
      result_array << string_copy.slice!(0..next_num_ind)
    end
  end
  #this is happening because I suck at regex
  def _next_num_index(string_copy)
    unless string_copy[0] =~ /\d/ || string_copy[0] == '-'
      return nil
    end
    for i in 1..string_copy.length
      unless string_copy[i] =~ /\d/
        if string_copy[i] =~ /\^/
          return nil
        else
          return i - 1
        end
      end
    end
    return string_copy.length - 1
  end

  def _add_next_function_arg(result_array,string_copy)
    frac_reg = /^\\frac\{\$*\}\{\$*\}/
    sliced = string_copy.slice!(frac_reg)
    result_array << sliced unless sliced.nil?
  end

  def _add_next_pow_arg(result_array,string_copy)
    # pow_reg = /((^\d+)|(^\(\$*\))|(^[A-Za-z]))\^(([A-Za-z])|(\d*)|(\{\$*\}))/
    pow_reg = /((^\d+)|(^\(\$*\))|(^[A-Za-z]))\^(([A-Za-z])|(\{\$*\})|(\d*))/
    sliced = string_copy.slice!(pow_reg)
    result_array << sliced unless sliced.nil?
  end


  def _add_next_brac_arg(result_array,string_copy)
    brac_reg = /^\(\$*\)(?!\^)/
    sliced = string_copy.slice!(brac_reg)
    result_array << sliced unless sliced.nil?
  end

  def reenter_str_content(string:,dollar_array:)
    i = 0
    dollar_array.each do |str|
      str.each_char.with_index do |c,c_i|
        if c != string[i]
          str[c_i] = string[i]
        end
        i += 1
      end
    end
  end

  def reenter_addition_str_content(string:,dollar_array:)
    i = 0
    dollar_array.each do |str|
      str.each_char.with_index do |c,c_i|
        if c != string[i]
          str[c_i] = string[i]
        end
        i += 1
      end
      i += 1  #accout for missing +
    end
  end

  def remove_enclosing_bracks(string_array:)
    string_array.each do |str|
      if str[0] == '(' && str[-1] == ')'
        str[0] = ''
        str[-1] = ''
      end
      if str[0] == '{' && str[-1] == '}'
        str[0] = ''
        str[-1] = ''
      end
    end
  end

end


## Too chicken to delete


  # def __next_arg_is_pow?(string_copy)
  #   string_copy =~ /^\d+\^/ || string_copy =~ /^\(\$*\)\^/ || string_copy =~ /^[A-Za-z]\^/
  # end


# def old_power

# if string_copy =~ /^\d+\^/
#   base_length = string_copy[/^\d+\^/].length
# end
#
# if string_copy =~ /^\(\$*\)\^/
#   base_length = string_copy[/^\(\$*\)\^/].length
# end
#
# if string_copy =~ /^[A-Za-z]\^/
#   base_length = string_copy[/^[A-Za-z]\^/].length
# end
#
# if __next_arg_is_pow?(string_copy) && string_copy[base_length] =~ /[A-Za-z]/
#   result_array << string_copy.slice!(0..(base_length))
#   return
# end
#
# if __next_arg_is_pow?(string_copy) && string_copy[base_length] =~ /\d*/
#   result_array << string_copy.slice!(0..(base_length))
#   return
# end
#
# if __next_arg_is_pow?(string_copy) && string_copy[base_length] =~ /\{/
#   pow_ind_end_i = matching_brackets(string_copy,brac_types[1][0],brac_types[1][1],1)[1]
#   result_array << string_copy.slice!(0..pow_ind_end_i)
#   return
# end
