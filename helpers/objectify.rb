module Objectify
  def objectify(str)
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
    #frac/div
      if str.include?('\frac{')
        args = str.scan(/\frac{(.*?)}/).flatten
        # str_to_del = ''


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
    left_brac_index = 0
    left_count = 0
    right_count = 0
    right_brac_index = 0
    str.each_char.with_index do |c,i|
      if c == left_brac
        left_count += 1
      end
      if c == right_brac
        right_count += 1
      end
      if left_count == brackets_num && left_brac == c
        left_brac_index = i
        left_count = 1
        right_count = 0
      end
      if left_count == right_count && right_count != 0
        right_brac_index = i
        break
      end
    end
    [left_brac_index,right_brac_index]
  end

end
