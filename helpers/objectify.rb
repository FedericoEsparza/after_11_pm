module Objectify
  def objectify(str)
    if str.include?('+')
      str_args = str.split('+')
      object_args = str_args.inject([]){ |r,e| r << objectify(e) }
      return add(object_args)
    end
    if str.length == 1 && /[A-Za-z]/ =~ str
      return str
    end
    if /[0-9]/ =~ str
      return str.to_i
    end
  end
end
