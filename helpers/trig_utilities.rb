module TrigUtilities
  def same_angles?(exp)
    result = true
    current_var = nil
    exp.args.each do |a|
      if (numerical?(a) || a.is_a?(string)) == false
        if a.is_a?(sine) || a.is_a?(cosine)
          if current_var == nil
            current_var = a.angle
          else
            if current_var != a.angle
              return false
            end
          end
        end
      end
    end
    return true
  end

end
