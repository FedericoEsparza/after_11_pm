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
    brackets_count = string.count BRACKET_TYPES[0][0]
    bracket_ranges_array = []
    i = 1

    while i < (brackets_count + 1)
      bracket_ranges_array << matching_brackets(string, BRACKET_TYPES[0][0], BRACKET_TYPES[0][1], i)
      i += 1
    end

    bracket_ranges_array.each do |brackets_range|
      start_index = brackets_range[0] + 1
      end_index = brackets_range[1] - 1

      string[start_index..end_index] = '$' * string[start_index..end_index].length
    end

    string
  end
end
