module Objectify
  BRACKET_TYPES = [['(',')'], ['{', '}'], ['[', ']']]

  def objectify(str)
    #frac/div
    if str =~ /^\\frac/
      str_copy = str.dup
      top_indices = matching_brackets(str_copy,'{','}')
      numerator = str_copy.slice(top_indices[0]+1..top_indices[1]-1)
      str_copy.slice!(0..top_indices[1])
      bot_indices = matching_brackets(str_copy,'{','}')
      denominator = str_copy.slice(bot_indices[0]+1..bot_indices[1]-1)
      str_args = [numerator,denominator]
      object_args = str_args.inject([]){ |r,e| r << objectify(e) }
      return div(object_args)
    end
    #2+x+y
    if str.include?('+')
      str_args = str.split('+')
      object_args = str_args.inject([]){ |r,e| r << objectify(e) }
      return add(object_args)
    end
    #2xyz
    if str.length > 1 && !(/[^A-Za-z0-9_]/ =~ str)
      str_args = str.split('')
      object_args = str_args.inject([]){ |r,e| r << objectify(e) }
      return mtp(object_args)
    end
    #string variable
    if str.length == 1 && /[A-Za-z]/ =~ str
      return str
    end
    #number
    if /[0-9]/ =~ str
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
      if str[i] == left_brac
        num_of_left_bracs += 1
      end
      i += 1
    end
    n_th_lbrac_index = i - 1
  end

  def empty_brackets(string:)
    type_1_brac_count = string.count BRACKET_TYPES[0][0]
    type_2_brac_count = string.count BRACKET_TYPES[1][0]
    type_3_brac_count = string.count BRACKET_TYPES[2][0]

    bracket_ranges_array = []

    type_1_i = 1
    while type_1_i < (type_1_brac_count + 1)
      bracket_ranges_array << matching_brackets(string, BRACKET_TYPES[0][0], BRACKET_TYPES[0][1], type_1_i)
      type_1_i += 1
    end

    type_2_i = 1
    while type_2_i < (type_2_brac_count + 1)
      bracket_ranges_array << matching_brackets(string, BRACKET_TYPES[1][0], BRACKET_TYPES[1][1], type_2_i)
      type_2_i += 1
    end

    type_3_i = 1
    while type_3_i < (type_3_brac_count + 1)
      bracket_ranges_array << matching_brackets(string, BRACKET_TYPES[2][0], BRACKET_TYPES[2][1], type_3_i)
      type_3_i += 1
    end

    bracket_ranges_array.each do |brackets_range|
      start_index = brackets_range[0] + 1
      end_index = brackets_range[1] - 1

      string[start_index..end_index] = '$' * string[start_index..end_index].length
    end

    string
    # brackets_count = string.count BRACKET_TYPES[0][0]
    # bracket_ranges_array = []
    # i = 1
    #
    # while i < (brackets_count + 1)
    #   bracket_ranges_array << matching_brackets(string, BRACKET_TYPES[0][0], BRACKET_TYPES[0][1], i)
    #   i += 1
    # end
    #
    # bracket_ranges_array.each do |brackets_range|
    #   start_index = brackets_range[0] + 1
    #   end_index = brackets_range[1] - 1
    #
    #   string[start_index..end_index] = '$' * string[start_index..end_index].length
    # end
    #
    # string
  end

  def split_mtp_args(string:)
    string_copy = string.dup
    result_array = []
    i = 0
    while string_copy.length != 0 && i < 20
      first_char = string_copy[0]
      #first char is numerical
      if first_char =~ /\d+/
        next_char = string_copy[1]
        if next_char =~ /\^/
          if string_copy[2] =~ /\w/
            result_array << string_copy.slice!(0..2)
          elsif string_copy[2] =~ /\(/
            end_of_second_index = matching_brackets(string_copy, BRACKET_TYPES[0][0], BRACKET_TYPES[0][1], 1)[1]
            result_array << string_copy.slice!(0..end_of_second_index)
          end
        else
          result_array << string_copy.slice!(0)
        end
        next
      end
      #first char is letter
      if first_char =~ /[A-Za-z]/
        next_char = string_copy[1]
        if next_char =~ /\^/
          if string_copy[2] =~ /\w/
            result_array << string_copy.slice!(0..2)
          elsif string_copy[2] =~ /\(/
            end_of_second_index = matching_brackets(string_copy, BRACKET_TYPES[0][0], BRACKET_TYPES[0][1], 1)[1]
            result_array << string_copy.slice!(0..end_of_second_index)
          end
        else
          result_array << string_copy.slice!(0)
        end
        next
      end
      #first char is \ for a function
      if first_char =~ /\\/
        func_end_index = _funciton_end_index(string: string_copy)
        result_array << string_copy.slice!(0..func_end_index)
        next
      end
      #first char is a (
      if first_char =~ /\(/
        func_end_index = _funciton_end_index(string: string_copy)
        next_char = string_copy[func_end_index + 1]
        #(   )next char is ^
        if next_char =~ /\^/
          if string_copy[func_end_index + 2] =~ /\w/
            result_array << string_copy.slice!(0..(func_end_index + 2))
          elsif string_copy[func_end_index + 2] =~ /\(/
            end_of_second_index = matching_brackets(string_copy, BRACKET_TYPES[0][0], BRACKET_TYPES[0][1], 2)[1]
            # puts "end of second index is #{end_of_second_index}"
            result_array << string_copy.slice!(0..end_of_second_index)
          end
        else
          result_array << string_copy.slice!(0..func_end_index)
        end
        next
      end
      i += 1
    end

    result_array
  end

  def _funciton_end_index(string:)
    bracket_num = 1
    bracket_num = 2 if string =~ /^\\frac/
    bracket_num = 1 if string =~ /^\\sin/
    bracket_num = 1 if string =~ /^\\cos/
    bracket_num = 1 if string =~ /^\\tan/
    bracket_num = 2 if string =~ /^\\log/

    matching_brackets(string, BRACKET_TYPES[0][0], BRACKET_TYPES[0][1], bracket_num)[1]
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

  # def remove_enclosing_bracks(string_array:)
  #
  # end

end
