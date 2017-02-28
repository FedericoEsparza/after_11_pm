module ObjectifyUtilities
  def brac_types
    [['(',')'], ['{', '}'], ['[', ']']]
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

  def empty_brackets(string)
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

  def split_mtp_args(string)
    string_copy = string.dup
    result_array = []
    i = 0
    while string_copy.length != 0 && i < 100
      _add_next_str_var_arg(result_array,string_copy)
      _add_next_num_arg(result_array,string_copy)
      _add_next_function_arg(result_array,string_copy)
      _add_next_pow_arg(result_array,string_copy)
      _add_next_brac_arg(result_array,string_copy)
      _delete_next_times_arg(string_copy)
      i += 1
    end
    result_array
  end

  def _delete_next_times_arg(string_copy)
    str_reg = /^\\times/
    sliced = string_copy.slice!(str_reg)
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
    # why this does not work?
    # pow_reg = /((^\d+)|(^\(\$*\))|(^[A-Za-z]))\^(([A-Za-z])|(\d*)|(\{\$*\}))/
    pow_reg = /((^\d+)|(^\(\$*\))|(^[A-Za-z]))\^(([A-Za-z])|(\{\$*\})|(\d))/
    sliced = string_copy.slice!(pow_reg)
    result_array << sliced unless sliced.nil?
  end


  def _add_next_brac_arg(result_array,string_copy)
    brac_reg = /^\(\$*\)(?!\^)/
    sliced = string_copy.slice!(brac_reg)
    result_array << sliced unless sliced.nil?
  end

  def reenter_str_content(string,dollar_array)
    string_copy = string.dup
    string_copy.gsub!('\\times','')
    i = 0
    dollar_array.each do |str|
      str.each_char.with_index do |c,c_i|
        if c != string_copy[i]
          str[c_i] = string_copy[i]
        end
        i += 1
      end
    end
  end

  def reenter_addition_str_content(string,dollar_array) #work same way for subtraction
    i = 0
    dollar_array.each do |str|
      str.each_char.with_index do |c,c_i|
        if c != string[i]
          str[c_i] = string[i]
        end
        i += 1
      end
      i += 1  #accout for missing + or -
    end
  end

  def remove_enclosing_bracks(string_array)
    string_array.each do |str|
      bracket_indices = matching_brackets(str,'(',')',brackets_num=1)
      if bracket_indices[1] != 0 && bracket_indices[0] == 0 && bracket_indices[1] == (str.length - 1)
        str[0] = ''
        str[-1] = ''
      end
      curly_bracket_indices = matching_brackets(str,'{','}',brackets_num=1)
      if curly_bracket_indices[1] != 0 && curly_bracket_indices[0] == 0 && curly_bracket_indices[1] == (str.length - 1)
        str[0] = ''
        str[-1] = ''
      end
    end
    # string_array.each do |str|
    #   if str[0] == '(' && str[-1] == ')'
    #     str[0] = ''
    #     str[-1] = ''
    #   end
    #   if str[0] == '{' && str[-1] == '}'
    #     str[0] = ''
    #     str[-1] = ''
    #   end
    # end
  end

end
