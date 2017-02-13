class Power
  attr_accessor :base, :index

  # def initialize(*args)
  #   if args.length == 1 && args[0].class == Array
  #     @args = args.first
  #   else
  #     @args = args
  #   end
  # end

  def initialize(base,index)
    @base = base
    @index = index
  end

  def ==(exp)
    base = exp.base && index = exp.index
    # args == exp.args
  end

  # def base
  #   args[0]
  # end
  #
  # def base=(value)
  #   args[0] = value
  # end
  #
  # def index
  #   args[1]
  # end
  #
  # def index=(value)
  #   args[1] = value
  # end


  def copy
    if base.is_a?(string) || base.is_a?(integer)
      copied_base = base
    else
      copied_base = base.copy
    end
    if index.is_a?(string) || index.is_a?(integer)
      copied_index = index
    else
      copied_index = index.copy
    end
    pow(copied_base,copied_index)
  end

  def evaluate
    # args[0] ** args[1]
    base ** index
  end
end
