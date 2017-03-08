include Factory
include Latex

class Division
  attr_accessor :args

  def initialize(*args)
    if args.length == 1 && args[0].class == Array
      @args = args.first
    else
      @args = args
    end
  end

  def top
    args[0]
  end

  def top=(value)
    self.args[0] = value
  end

  def bot
    args[1]
  end

  def bot=(value)
    self.args[1] = value
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
    div(new_args)
  end

  def evaluate_numeral
    args[0]/args[1]
  end

  def contains?(subject)
    result = false
    if self == subject
      result = true
    else
      args.each do |arg|
        if arg.contains?(subject)
          result = true
        end
      end
    end
    result
  end

  def reverse_subject_step(subject,rs)
    result = {}

    if top.contains?(subject)
      result[:ls] = top
      result[:rs] = mtp(rs,bot)
      return result
    elsif bot.contains?(subject)
      result[:ls] = bot
      result[:rs] = div(top,rs)
      return result
    end
  end

  def reverse_step(rs)
    result = {}
    if args[0].is_a?(integer)
      result[:ls] = args[1]
      result[:rs] = div(args[0],rs)
      return result
    end
    if args[1].is_a?(integer)
      result[:ls] = args[0]
      result[:rs] = mtp(rs,args[1])
      return result
    end
  end

  def base_latex
    '\displaystyle\frac{' + top.base_latex + '}{' + bot.base_latex + '}'
  end

end
