module TrigUtilities
  def first_trig_angle(exp)
    exp.args.each do |a|
      if (numerical?(a) || a.is_a?(string)) == false
        if a.is_a?(sine) || a.is_a?(cosine) || a.is_a?(tangent)
          return a.angle
        else
          angle = first_trig_angle(a)
          return angle.copy unless angle.nil?
        end
      end
    end
    return nil
  end

  def same_angles?(exp)
    angle = first_trig_angle(exp)
    return false if angle.nil?
    _all_has_this_angle?(exp,angle)
  end

  def _all_has_this_angle?(exp,angle)
    exp.args.each do |a|
      if (numerical?(a) || a.is_a?(string)) == false
        if a.is_a?(sine) || a.is_a?(cosine) || a.is_a?(tangent)
          return false if angle != a.angle
        else
          return false unless _all_has_this_angle?(a,angle)
        end
      end
    end
    return true
  end

  def fix_nums_to_one(exp)
    exp_copy = exp.copy
    if exp_copy.is_a?(string)
      return exp_copy
    end
    if numerical?(exp_copy)
      return 1
    end
    new_args = exp_copy.args.map do |arg|
      fix_nums_to_one(arg)
    end
    return exp_copy.class.new(new_args)
  end

  def fix_angles_to_x(exp)
    exp_copy = exp.copy
    if exp_copy.is_a?(sine) || exp_copy.is_a?(cosine) || exp_copy.is_a?(tangent)
      return exp_copy.class.new('x')
    end
    if exp_copy.is_a?(string) || numerical?(exp)
      return exp
    end
    new_args = exp_copy.args.map do |arg|
      fix_angles_to_x(arg)
    end
    return exp_copy.class.new(new_args)
  end

end
