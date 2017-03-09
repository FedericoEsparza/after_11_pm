module TrigUtilities
  def same_angles?(exp)
    angle = first_trig_angle(exp)
    all_trig_this_angle?(exp,angle)
    # result = true
    # current_var = nil
    # exp.args.each do |a|
    #   if (numerical?(a) || a.is_a?(string)) == false
    #     if a.is_a?(sine) || a.is_a?(cosine)
    #       if current_var == nil
    #         current_var = a.angle
    #       else
    #         if current_var != a.angle
    #           return false
    #         end
    #       end
    #     else #not string num or trig
    #
    #
    #     end
    #   end
    # end
    # return true
  end

  def first_trig_angle(exp)
    exp.args.each do |a|
      if (numerical?(a) || a.is_a?(string)) == false
        if a.is_a?(sine) || a.is_a?(cosine)
          return a.angle
        else
          angle = first_trig_angle(a)
          return angle unless angle.nil?
        end
      end
    end
    return nil
  end

  def all_trig_this_angle?(exp,angle)
    current_var = angle
    exp.args.each do |a|
      if (numerical?(a) || a.is_a?(string)) == false
        if a.is_a?(sine) || a.is_a?(cosine)
          if current_var != a.angle
            return false
          end
        else #not string num or trig


        end
      end
    end
    return true
  end

end
