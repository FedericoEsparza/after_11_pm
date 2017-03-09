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
          if angle != a.angle
            return false
          end
        else #not string num or trig
          arg_same_angle = _all_has_this_angle?(a,angle)
          return false if arg_same_angle == false
        end
      end
    end
    return true
  end

end
