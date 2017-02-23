require './models/factory'

include Factory

class Cosine
  attr_accessor :args

  def initialize(*args)
    if args.length == 1 && args[0].class == Array
      @args = args.first
    else
      @args = args
    end
  end

  def angle
    args[0]
  end

  def angle=(angle)
    self.args[0] = angle
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
    cos(new_args)
  end

  def evaluate_numeral
    rad = angle.to_f / 180 * (Math::PI)
    Math.cos(rad).round(5)
  end

  def reverse_step(rs)
    result = {}
    result[:ls] = args[0]
    result[:rs] = arccos(rs)
    result
  end

  def latex
    angle_latex = angle.latex
    if angle.is_a?(addition) || angle.is_a?(subtraction)
      angle_latex = brackets(angle_latex)
    end
      '\cos ' + angle_latex
  end
end
