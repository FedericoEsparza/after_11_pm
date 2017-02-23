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
    #string variable
    if str.length == 1 && /[A-Za-z]/ =~ str
      return str
    end
    #number
    if /[0-9]/ =~ str
      return str.to_i
    end
  end
end
