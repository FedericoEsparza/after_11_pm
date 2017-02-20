require './models/factory'

include Factory

class Addition
  attr_accessor :args

  def initialize(*args)
    if args.length == 1 && args[0].class == Array
      @args = args.first
    else
      @args = args
    end
  end

  def ==(exp)
    exp.class == self.class && args == exp.args
  end

  def copy
    new_args = args.inject([]) do |r,e|
      if e.is_a?(string) || numerical?(e)
        r << e
      else
        r << e.copy
      end
    end
    add(new_args)
  end

  def evaluate
    args.inject(0){ |r, arg|
      arg = arg.is_a?(Numeral) ? arg.value : arg
      r + arg
    }
  end

  def evaluate_numeral
    args.inject(0){|r,e| r + e}
  end

  def reverse_step(rs)
    result = {}
    if args[0].is_a?(integer)
      result[:ls] = args[1]
      result[:rs] = sbt(rs,args[0])
      return result
    end
    if args[1].is_a?(integer)
      result[:ls] = args[0]
      result[:rs] = sbt(rs,args[1])
      return result
    end
  end
end
