class Tangent < BaseTrigonometry
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

  def evaluate_numeral
    rad = angle.to_f / 180 * (Math::PI)
    Math.tan(rad).round(5)
  end

  def reverse_step(rs)
    result = {}
    result[:ls] = args[0]
    result[:rs] = arctan(rs)
    result
  end

  def base_latex
    angle_latex = angle.base_latex
    if angle.is_a?(addition) || angle.is_a?(subtraction)
      angle_latex = brackets(angle_latex)
    end
    '\tan ' + angle_latex
  end
end
